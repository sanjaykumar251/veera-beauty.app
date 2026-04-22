const Course = require('../models/Course');
const Progress = require('../models/Progress');
const User = require('../models/User');

// ─── Get All Published Courses ────────────────────────────────────────────────
exports.getCourses = async (req, res) => {
  try {
    const { category } = req.query;
    const filter = { isPublished: true };
    if (category) filter.category = category;

    const courses = await Course.find(filter)
      .select('-modules.lessons.youtubeVideoId -previewVideoId')
      .sort({ isFeatured: -1, createdAt: -1 });

    res.json({ success: true, courses });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Get Course Detail ────────────────────────────────────────────────────────
exports.getCourse = async (req, res) => {
  try {
    const course = await Course.findById(req.params.id);
    if (!course || !course.isPublished) {
      return res.status(404).json({ success: false, message: 'Course not found' });
    }

    const user = req.user;
    const isEnrolled = user?.enrolledCourses?.some(
      ec => ec.courseId.toString() === req.params.id
    );

    const sanitized = course.toObject();
    sanitized.previewVideoId = null;
    sanitized.modules = sanitized.modules.map(mod => ({
      ...mod,
      lessons: mod.lessons.map(lesson => ({
        ...lesson,
        youtubeVideoId: null,
      })),
    }));

    if (!isEnrolled) {
      return res.json({ success: true, course: sanitized, isEnrolled: false });
    }

    // Get progress if enrolled
    const progress = await Progress.findOne({ userId: user._id, courseId: req.params.id });
    res.json({ success: true, course: sanitized, isEnrolled: true, progress });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Get My Enrolled Courses ──────────────────────────────────────────────────
exports.getMyCourses = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).populate('enrolledCourses.courseId');
    const enrolledCourses = user.enrolledCourses || [];

    const courseIds = enrolledCourses.map(ec => ec.courseId?._id).filter(Boolean);
    const progresses = await Progress.find({ userId: req.user._id, courseId: { $in: courseIds } });

    const result = enrolledCourses.map(ec => {
      const prog = progresses.find(p => p.courseId.toString() === ec.courseId?._id?.toString());
      return {
        ...ec.courseId?.toObject?.(),
        enrolledAt: ec.enrolledAt,
        progress: prog?.percentageComplete || 0,
        lastAccessed: prog?.lastAccessedAt,
      };
    });

    res.json({ success: true, courses: result });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Update Lesson Progress ───────────────────────────────────────────────────
exports.updateProgress = async (req, res) => {
  try {
    const { courseId, lessonId, moduleId, completed, lastPosition } = req.body;

    const course = await Course.findById(courseId);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found' });

    // Check enrollment
    const isEnrolled = req.user.enrolledCourses?.some(ec => ec.courseId.toString() === courseId);
    if (!isEnrolled) return res.status(403).json({ success: false, message: 'Not enrolled in this course' });

    let progress = await Progress.findOne({ userId: req.user._id, courseId });
    if (!progress) {
      progress = new Progress({ userId: req.user._id, courseId, lessons: [] });
    }

    // Update or add lesson progress
    const existingLesson = progress.lessons.find(l => l.lessonId.toString() === lessonId);
    if (existingLesson) {
      existingLesson.completed = completed ?? existingLesson.completed;
      existingLesson.lastPosition = lastPosition ?? existingLesson.lastPosition;
      if (completed) existingLesson.completedAt = new Date();
    } else {
      progress.lessons.push({
        lessonId,
        moduleId,
        completed: completed ?? false,
        lastPosition: lastPosition ?? 0,
        completedAt: completed ? new Date() : null,
      });
    }

    // Calculate overall percentage
    const totalLessons = course.modules.reduce((t, m) => t + m.lessons.length, 0);
    const completedLessons = progress.lessons.filter(l => l.completed).length;
    progress.percentageComplete = totalLessons > 0 ? Math.round((completedLessons / totalLessons) * 100) : 0;
    progress.lastAccessedAt = new Date();

    await progress.save();
    res.json({ success: true, progress });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Admin: Create Course ─────────────────────────────────────────────────────
exports.createCourse = async (req, res) => {
  try {
    const course = await Course.create(req.body);
    res.status(201).json({ success: true, course });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

// ─── Admin: Update Course ─────────────────────────────────────────────────────
exports.updateCourse = async (req, res) => {
  try {
    const course = await Course.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!course) return res.status(404).json({ success: false, message: 'Course not found' });
    res.json({ success: true, course });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

// ─── Admin: Delete Course ─────────────────────────────────────────────────────
exports.deleteCourse = async (req, res) => {
  try {
    await Course.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Course deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Admin: Add Module to Course ─────────────────────────────────────────────
exports.addModule = async (req, res) => {
  try {
    const course = await Course.findById(req.params.id);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found' });
    course.modules.push(req.body);
    await course.save();
    res.json({ success: true, course });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

// ─── Admin: Add Lesson to Module ─────────────────────────────────────────────
exports.addLesson = async (req, res) => {
  try {
    const course = await Course.findById(req.params.courseId);
    const module = course?.modules.id(req.params.moduleId);
    if (!module) return res.status(404).json({ success: false, message: 'Module not found' });
    module.lessons.push(req.body);
    await course.save();
    res.json({ success: true, course });
  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};
