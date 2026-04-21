const mongoose = require('mongoose');

// ─── Lesson ───────────────────────────────────────────────────────────────────
const lessonSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true },
  description: String,
  youtubeVideoId: {
    type: String,
    required: true,
    // Store only the video ID, e.g. "dQw4w9WgXcQ"
  },
  duration: Number, // in seconds
  order: { type: Number, default: 0 },
  isFreePreview: { type: Boolean, default: false },
  thumbnail: String,
}, { timestamps: true });

// ─── Module ───────────────────────────────────────────────────────────────────
const moduleSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true },
  description: String,
  order: { type: Number, default: 0 },
  lessons: [lessonSchema],
}, { timestamps: true });

// ─── Course ───────────────────────────────────────────────────────────────────
const courseSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Course title is required'],
    trim: true,
  },
  subtitle: String,
  description: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    enum: ['makeup', 'hair', 'skin', 'nail', 'mehendi', 'bridal', 'tattoo', 'grooming', 'business'],
    required: true,
  },
  thumbnail: String,
  previewVideoId: String, // YouTube ID for course trailer
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  discountedPrice: {
    type: Number,
    default: null,
  },
  language: {
    type: String,
    default: 'Tamil',
  },
  level: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    default: 'beginner',
  },
  modules: [moduleSchema],

  // Stats
  totalStudents: { type: Number, default: 0 },
  rating: { type: Number, default: 0 },
  totalRatings: { type: Number, default: 0 },

  // Visibility
  isPublished: { type: Boolean, default: false },
  isFeatured: { type: Boolean, default: false },

  // What students will learn
  whatYouLearn: [String],
  requirements: [String],
  instructor: {
    type: String,
    default: "Veera's Beauty Academy",
  },
}, { timestamps: true });

// Virtual: effective price
courseSchema.virtual('effectivePrice').get(function () {
  return this.discountedPrice && this.discountedPrice < this.price
    ? this.discountedPrice
    : this.price;
});

// Virtual: total duration in seconds
courseSchema.virtual('totalDuration').get(function () {
  return this.modules.reduce((total, mod) => {
    return total + mod.lessons.reduce((t, l) => t + (l.duration || 0), 0);
  }, 0);
});

// Virtual: total lessons count
courseSchema.virtual('totalLessons').get(function () {
  return this.modules.reduce((total, mod) => total + mod.lessons.length, 0);
});

courseSchema.set('toJSON', { virtuals: true });
courseSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('Course', courseSchema);
