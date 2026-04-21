const User = require('../models/User');
const admin = require('../config/firebase');

const VIP_PRICE = 999;
const VIP_DURATION_DAYS = 365;

// ─── Get VIP Plan Info + QR ───────────────────────────────────────────────────
exports.getVIPPlan = async (req, res) => {
  try {
    const user = req.user;
    res.json({
      success: true,
      plan: {
        name: 'VIP Loyalty Membership',
        price: VIP_PRICE,
        currency: 'INR',
        duration: '1 Year',
        benefits: [
          'Yearly package for regular clients',
          'Priority booking support',
          '11th service FREE after 10 visits',
          '5% extra off on bridal bookings',
          'Selected Buy 1 Get 1 offers',
        ],
        upiId: process.env.GPAY_UPI_ID || 'veeras@upi',
        upiName: process.env.BUSINESS_NAME || "Veera's Beauty & Tattoo Studio",
        gpayQRUrl: `/api/payment/qr?amount=${VIP_PRICE}&note=VIP+Membership`,
      },
      currentMembership: user ? {
        type: user.membershipType,
        isVIP: user.isVIP,
        expiry: user.membershipExpiry,
        totalBookings: user.totalBookings,
        nextFreeAt: user.membershipType === 'vip'
          ? Math.ceil((user.totalBookings + 1) / 11) * 11 || 11
          : null,
      } : null,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Admin: Manually Activate VIP ────────────────────────────────────────────
exports.activateVIP = async (req, res) => {
  try {
    const { userId, paymentRef } = req.body;
    const expiry = new Date();
    expiry.setDate(expiry.getDate() + VIP_DURATION_DAYS);

    const user = await User.findByIdAndUpdate(
      userId,
      {
        membershipType: 'vip',
        membershipExpiry: expiry,
        membershipPurchasedAt: new Date(),
      },
      { new: true }
    );

    if (!user) return res.status(404).json({ success: false, message: 'User not found' });

    // Send notification
    if (user.fcmToken) {
      try {
        await admin.messaging().send({
          token: user.fcmToken,
          notification: {
            title: '🎉 You are now a VIP Member!',
            body: `Enjoy 10% off all services and priority booking for 1 year!`,
          },
        });
      } catch {}
    }

    res.json({ success: true, message: 'VIP activated', user, expiry });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Check My VIP Status ──────────────────────────────────────────────────────
exports.getMyMembership = async (req, res) => {
  try {
    const user = req.user;
    const isExpired = user.membershipType === 'vip' && user.membershipExpiry && new Date() > user.membershipExpiry;

    if (isExpired) {
      // Downgrade expired VIP
      await User.findByIdAndUpdate(user._id, { membershipType: 'normal' });
    }

    res.json({
      success: true,
      membership: {
        type: isExpired ? 'normal' : user.membershipType,
        isVIP: user.isVIP && !isExpired,
        expiry: user.membershipExpiry,
        totalBookings: user.totalBookings,
        nextFreeBookingAt: user.totalBookings > 0
          ? Math.ceil((user.totalBookings + 1) / 11) * 11
          : 11,
        isExpired,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
