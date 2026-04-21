const Booking = require('../models/Booking');
const Service = require('../models/Service');
const User = require('../models/User');
const admin = require('../config/firebase');

// ─── Calculate VIP Price ──────────────────────────────────────────────────────
const applyVIPDiscount = (user, service) => {
  if (!user || !user.isVIP) return { discount: 0, finalPrice: service.price };
  const discountPct = user.getDiscount(service.category === 'bridal' ? 'bridal' : 'normal');
  const finalPrice = Math.round(service.price * (1 - discountPct / 100));
  return { discount: discountPct, finalPrice };
};

// ─── Create Booking (Guest or Logged-in) ──────────────────────────────────────
exports.createBooking = async (req, res) => {
  try {
    const {
      serviceId, date, timeSlot,
      guestName, guestPhone, guestEmail,
      specialRequests,
    } = req.body;

    const service = await Service.findById(serviceId);
    if (!service || !service.isAvailable) {
      return res.status(404).json({ success: false, message: 'Service not available' });
    }

    const user = req.user || null;

    // VIP logic
    let isFreeService = false;
    let discount = 0;
    let finalPrice = service.price;

    if (user && user.isVIP) {
      const vipCalc = applyVIPDiscount(user, service);
      discount = vipCalc.discount;
      finalPrice = vipCalc.finalPrice;

      // 11th booking free logic
      if (user.totalBookings > 0 && (user.totalBookings + 1) % 11 === 0) {
        isFreeService = true;
        finalPrice = 0;
        discount = 100;
      }
    }

    const booking = await Booking.create({
      userId: user?._id || null,
      guestName: user ? (guestName || user.name) : guestName,
      guestPhone: user ? (guestPhone || user.phone) : guestPhone,
      guestEmail: user ? (guestEmail || user.email) : guestEmail,
      serviceId,
      serviceName: service.name,
      serviceCategory: service.category,
      date: new Date(date),
      timeSlot,
      originalPrice: service.price,
      discountApplied: discount,
      finalPrice,
      isVIPBooking: !!(user && user.isVIP),
      isFreeService,
      isPriorityBooking: !!(user && user.isVIP),
      specialRequests,
    });

    // Increment user booking count
    if (user) {
      await User.findByIdAndUpdate(user._id, { $inc: { totalBookings: 1 } });
    }

    // Send push notification if user has FCM token
    if (user?.fcmToken) {
      try {
        await admin.messaging().send({
          token: user.fcmToken,
          notification: {
            title: '✅ Booking Confirmed!',
            body: `Your ${service.name} on ${new Date(date).toLocaleDateString('en-IN')} at ${timeSlot} is confirmed.`,
          },
          data: { bookingId: booking._id.toString(), type: 'booking_confirmed' },
        });
      } catch (fcmErr) {
        console.warn('FCM send failed:', fcmErr.message);
      }
    }

    res.status(201).json({
      success: true,
      message: 'Booking created successfully',
      booking,
      whatsappLink: `https://wa.me/918344549199?text=Hi%2C%20I%20booked%20${encodeURIComponent(service.name)}%20for%20${encodeURIComponent(new Date(date).toLocaleDateString('en-IN'))}%20at%20${encodeURIComponent(timeSlot)}`,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Get My Bookings ──────────────────────────────────────────────────────────
exports.getMyBookings = async (req, res) => {
  try {
    const bookings = await Booking.find({ userId: req.user._id })
      .populate('serviceId', 'name category image')
      .sort({ createdAt: -1 });
    res.json({ success: true, bookings });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Get Single Booking ───────────────────────────────────────────────────────
exports.getBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id).populate('serviceId');
    if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });

    // Check ownership
    if (req.user && booking.userId?.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
      return res.status(403).json({ success: false, message: 'Access denied' });
    }
    res.json({ success: true, booking });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Cancel Booking ───────────────────────────────────────────────────────────
exports.cancelBooking = async (req, res) => {
  try {
    const booking = await Booking.findById(req.params.id);
    if (!booking) return res.status(404).json({ success: false, message: 'Booking not found' });
    if (booking.userId?.toString() !== req.user._id.toString()) {
      return res.status(403).json({ success: false, message: 'Access denied' });
    }
    if (booking.status === 'completed') {
      return res.status(400).json({ success: false, message: 'Cannot cancel a completed booking' });
    }
    booking.status = 'cancelled';
    await booking.save();
    res.json({ success: true, message: 'Booking cancelled', booking });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Admin: Get All Bookings ──────────────────────────────────────────────────
exports.getAllBookings = async (req, res) => {
  try {
    const { status, date, page = 1, limit = 20 } = req.query;
    const filter = {};
    if (status) filter.status = status;
    if (date) {
      const d = new Date(date);
      filter.date = { $gte: d, $lt: new Date(d.getTime() + 86400000) };
    }

    const bookings = await Booking.find(filter)
      .populate('userId', 'name phone email membershipType')
      .populate('serviceId', 'name category')
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await Booking.countDocuments(filter);
    res.json({ success: true, bookings, total, page: parseInt(page), totalPages: Math.ceil(total / limit) });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Admin: Update Booking Status ─────────────────────────────────────────────
exports.updateBookingStatus = async (req, res) => {
  try {
    const { status, adminNotes, paymentStatus } = req.body;
    const booking = await Booking.findByIdAndUpdate(
      req.params.id,
      { status, adminNotes, paymentStatus },
      { new: true }
    ).populate('userId', 'fcmToken name');

    if (booking?.userId?.fcmToken) {
      try {
        await admin.messaging().send({
          token: booking.userId.fcmToken,
          notification: {
            title: `Booking ${status}`,
            body: `Your booking for ${booking.serviceName} has been ${status}.`,
          },
        });
      } catch {}
    }

    res.json({ success: true, booking });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
