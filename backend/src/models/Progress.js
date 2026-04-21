const mongoose = require('mongoose');

const progressSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true,
  },
  // Lesson-level progress
  lessons: [{
    lessonId: mongoose.Schema.Types.ObjectId,
    moduleId: mongoose.Schema.Types.ObjectId,
    completed: { type: Boolean, default: false },
    lastPosition: { type: Number, default: 0 }, // seconds watched
    completedAt: Date,
  }],
  // Overall course progress
  percentageComplete: {
    type: Number,
    default: 0,
    min: 0,
    max: 100,
  },
  lastAccessedAt: {
    type: Date,
    default: Date.now,
  },
  completedAt: Date,
}, { timestamps: true });

progressSchema.index({ userId: 1, courseId: 1 }, { unique: true });

module.exports = mongoose.model('Progress', progressSchema);
