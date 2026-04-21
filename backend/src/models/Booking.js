const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  // User reference (optional for guests)
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null,
  },

  // Guest info (required if no userId)
  guestName: {
    type: String,
    trim: true,
  },
  guestPhone: {
    type: String,
    trim: true,
  },
  guestEmail: {
    type: String,
    trim: true,
    lowercase: true,
  },

  // Service
  serviceId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Service',
    required: true,
  },
  serviceName: String,
  serviceCategory: String,

  // Scheduling
  date: {
    type: Date,
    required: [true, 'Booking date is required'],
  },
  timeSlot: {
    type: String,
    required: [true, 'Time slot is required'],
  },

  // Pricing
  originalPrice: {
    type: Number,
    required: true,
  },
  discountApplied: {
    type: Number,
    default: 0, // percentage
  },
  finalPrice: {
    type: Number,
    required: true,
  },

  // VIP Logic
  isVIPBooking: {
    type: Boolean,
    default: false,
  },
  isFreeService: {
    type: Boolean,
    default: false, // 11th booking free for VIP
  },
  isPriorityBooking: {
    type: Boolean,
    default: false,
  },

  // Status
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'completed', 'cancelled'],
    default: 'pending',
  },

  // Notes
  specialRequests: String,
  adminNotes: String,

  // Payment (QR/manual)
  paymentStatus: {
    type: String,
    enum: ['pending', 'paid', 'waived'],
    default: 'pending',
  },
}, { timestamps: true });

// Index for efficient queries
bookingSchema.index({ userId: 1, date: -1 });
bookingSchema.index({ date: 1, status: 1 });
bookingSchema.index({ status: 1, createdAt: -1 });

module.exports = mongoose.model('Booking', bookingSchema);
