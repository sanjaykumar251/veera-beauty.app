const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  // Identity
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
    maxlength: [100, 'Name cannot exceed 100 characters'],
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\S+@\S+\.\S+$/, 'Please enter a valid email'],
  },
  phone: {
    type: String,
    trim: true,
    match: [/^[6-9]\d{9}$/, 'Please enter a valid 10-digit Indian phone number'],
  },
  password: {
    type: String,
    minlength: 6,
    select: false,
  },

  // Firebase
  firebaseUid: {
    type: String,
    unique: true,
    sparse: true,
  },

  // Role
  role: {
    type: String,
    enum: ['user', 'admin'],
    default: 'user',
  },

  // Membership
  membershipType: {
    type: String,
    enum: ['normal', 'vip'],
    default: 'normal',
  },
  membershipExpiry: {
    type: Date,
    default: null,
  },
  membershipPurchasedAt: {
    type: Date,
    default: null,
  },

  // Booking stats (for VIP "11th free" logic)
  totalBookings: {
    type: Number,
    default: 0,
  },
  freeServiceEligible: {
    type: Boolean,
    default: false,
  },

  // Enrolled courses
  enrolledCourses: [{
    courseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Course' },
    enrolledAt: { type: Date, default: Date.now },
    paidAmount: Number,
  }],

  // FCM push token
  fcmToken: {
    type: String,
    default: null,
  },

  // Profile
  avatar: String,
  isActive: {
    type: Boolean,
    default: true,
  },
}, { timestamps: true });

// ─── Virtual: isVIP ───────────────────────────────────────────────────────────
userSchema.virtual('isVIP').get(function () {
  if (this.membershipType !== 'vip') return false;
  if (!this.membershipExpiry) return false;
  return new Date() < new Date(this.membershipExpiry);
});

// ─── Hash Password Before Save ────────────────────────────────────────────────
userSchema.pre('save', async function (next) {
  if (!this.isModified('password') || !this.password) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

// ─── Compare Password ─────────────────────────────────────────────────────────
userSchema.methods.comparePassword = async function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

// ─── Check VIP Discount ───────────────────────────────────────────────────────
userSchema.methods.getDiscount = function (serviceType) {
  if (!this.isVIP) return 0;
  if (serviceType === 'bridal') return 15; // 10% base + 5% bridal
  return 10;
};

userSchema.set('toJSON', { virtuals: true });
userSchema.set('toObject', { virtuals: true });

module.exports = mongoose.model('User', userSchema);
