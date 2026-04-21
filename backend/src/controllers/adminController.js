const User = require('../models/User');
const Booking = require('../models/Booking');
const Course = require('../models/Course');
const Service = require('../models/Service');

// ─── Dashboard Stats ──────────────────────────────────────────────────────────
exports.getDashboard = async (req, res) => {
  try {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const [
      totalUsers, vipUsers, totalBookings, monthlyBookings,
      pendingBookings, totalCourses, totalRevenue
    ] = await Promise.all([
      User.countDocuments({ role: 'user' }),
      User.countDocuments({ membershipType: 'vip', membershipExpiry: { $gt: now } }),
      Booking.countDocuments(),
      Booking.countDocuments({ createdAt: { $gte: startOfMonth } }),
      Booking.countDocuments({ status: 'pending' }),
      Course.countDocuments({ isPublished: true }),
      Booking.aggregate([
        { $match: { paymentStatus: 'paid' } },
        { $group: { _id: null, total: { $sum: '$finalPrice' } } },
      ]),
    ]);

    // Monthly revenue breakdown
    const monthlyRevenue = await Booking.aggregate([
      { $match: { paymentStatus: 'paid', createdAt: { $gte: new Date(now.getFullYear(), 0, 1) } } },
      { $group: { _id: { month: { $month: '$createdAt' } }, revenue: { $sum: '$finalPrice' }, count: { $sum: 1 } } },
      { $sort: { '_id.month': 1 } },
    ]);

    // Recent bookings
    const recentBookings = await Booking.find()
      .populate('userId', 'name phone')
      .populate('serviceId', 'name')
      .sort({ createdAt: -1 })
      .limit(10);

    res.json({
      success: true,
      stats: {
        totalUsers,
        vipUsers,
        totalBookings,
        monthlyBookings,
        pendingBookings,
        totalCourses,
        totalRevenue: totalRevenue[0]?.total || 0,
      },
      monthlyRevenue,
      recentBookings,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Get All Users ────────────────────────────────────────────────────────────
exports.getUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20, search, membership } = req.query;
    const filter = { role: 'user' };
    if (search) filter.$or = [
      { name: { $regex: search, $options: 'i' } },
      { email: { $regex: search, $options: 'i' } },
      { phone: { $regex: search, $options: 'i' } },
    ];
    if (membership) filter.membershipType = membership;

    const users = await User.find(filter)
      .select('-password')
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await User.countDocuments(filter);
    res.json({ success: true, users, total, totalPages: Math.ceil(total / limit) });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Update User ──────────────────────────────────────────────────────────────
exports.updateUser = async (req, res) => {
  try {
    const { membershipType, membershipExpiry, role, isActive } = req.body;
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { membershipType, membershipExpiry, role, isActive },
      { new: true }
    );
    res.json({ success: true, user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Enroll User in Course (manual/after payment verification) ────────────────
exports.enrollUserInCourse = async (req, res) => {
  try {
    const { userId, courseId, paidAmount } = req.body;
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });

    const alreadyEnrolled = user.enrolledCourses.some(ec => ec.courseId.toString() === courseId);
    if (alreadyEnrolled) return res.status(409).json({ success: false, message: 'Already enrolled' });

    user.enrolledCourses.push({ courseId, paidAmount });
    await user.save();

    // Increment course student count
    await Course.findByIdAndUpdate(courseId, { $inc: { totalStudents: 1 } });

    res.json({ success: true, message: 'User enrolled in course' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Send Push Notification ───────────────────────────────────────────────────
exports.sendNotification = async (req, res) => {
  try {
    const admin = require('../config/firebase');
    const { title, body, userIds, topic } = req.body;

    if (topic) {
      await admin.messaging().send({ topic, notification: { title, body } });
    } else if (userIds && userIds.length > 0) {
      const users = await User.find({ _id: { $in: userIds }, fcmToken: { $ne: null } }).select('fcmToken');
      const tokens = users.map(u => u.fcmToken).filter(Boolean);
      if (tokens.length > 0) {
        await admin.messaging().sendEachForMulticast({ tokens, notification: { title, body } });
      }
    }
    res.json({ success: true, message: 'Notification sent' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
