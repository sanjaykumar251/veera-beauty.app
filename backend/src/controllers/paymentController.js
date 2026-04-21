const QRCode = require('qrcode');

// ─── Generate GPay/UPI QR Code ────────────────────────────────────────────────
exports.generateQR = async (req, res) => {
  try {
    const { amount, note } = req.query;
    const upiId = process.env.GPAY_UPI_ID || 'veeras@upi';
    const name = encodeURIComponent(process.env.BUSINESS_NAME || "Veera's Beauty & Tattoo Studio");
    const encodedNote = encodeURIComponent(note || 'Payment');

    // UPI deep link format
    const upiUrl = `upi://pay?pa=${upiId}&pn=${name}&am=${amount || ''}&cu=INR&tn=${encodedNote}`;

    // Generate QR as base64 PNG
    const qrDataUrl = await QRCode.toDataURL(upiUrl, {
      width: 300,
      margin: 2,
      color: { dark: '#1a1a2e', light: '#ffffff' },
    });

    res.json({
      success: true,
      qrDataUrl,        // base64 PNG for Flutter Image.memory
      upiUrl,           // deep link for GPay button
      upiId,
      amount: parseFloat(amount) || 0,
      note,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Mark Course Payment Verified (manual admin step) ─────────────────────────
exports.verifyCoursePayment = async (req, res) => {
  try {
    const { userId, courseId, amount, transactionRef } = req.body;
    const User = require('../models/User');
    const Course = require('../models/Course');

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ success: false, message: 'User not found' });

    const alreadyEnrolled = user.enrolledCourses.some(ec => ec.courseId.toString() === courseId);
    if (alreadyEnrolled) return res.status(409).json({ success: false, message: 'Already enrolled' });

    user.enrolledCourses.push({ courseId, paidAmount: amount });
    await user.save();

    await Course.findByIdAndUpdate(courseId, { $inc: { totalStudents: 1 } });

    // Send notification
    if (user.fcmToken) {
      try {
        const admin = require('../config/firebase');
        const course = await Course.findById(courseId);
        await admin.messaging().send({
          token: user.fcmToken,
          notification: {
            title: '🎓 Course Unlocked!',
            body: `Your payment for "${course?.title}" is confirmed. Start learning now!`,
          },
          data: { courseId, type: 'course_enrolled' },
        });
      } catch {}
    }

    res.json({ success: true, message: 'Payment verified and course unlocked', transactionRef });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
