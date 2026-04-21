const admin = require('../config/firebase');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// ─── Register with Email/Password ─────────────────────────────────────────────
exports.register = async (req, res) => {
  try {
    const { name, email, phone, password, firebaseUid } = req.body;

    if (!name || !email) {
      return res.status(400).json({ success: false, message: 'Name and email are required' });
    }

    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(409).json({ success: false, message: 'Email already registered' });
    }

    const user = await User.create({ name, email, phone, password, firebaseUid });
    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        membershipType: user.membershipType,
        isVIP: user.isVIP,
        role: user.role,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Login with Email/Password ────────────────────────────────────────────────
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email }).select('+password');
    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ success: false, message: 'Invalid email or password' });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });

    res.json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        membershipType: user.membershipType,
        membershipExpiry: user.membershipExpiry,
        isVIP: user.isVIP,
        totalBookings: user.totalBookings,
        enrolledCourses: user.enrolledCourses,
        role: user.role,
      },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Firebase Login / Register ────────────────────────────────────────────────
exports.firebaseAuth = async (req, res) => {
  try {
    const { firebaseToken, name, phone } = req.body;
    if (!firebaseToken) {
      return res.status(400).json({ success: false, message: 'Firebase token required' });
    }

    const decoded = await admin.auth().verifyIdToken(firebaseToken);
    let user = await User.findOne({ firebaseUid: decoded.uid });

    if (!user) {
      // Create new user from Firebase
      user = await User.create({
        name: name || decoded.name || 'User',
        email: decoded.email || `${decoded.uid}@firebase.user`,
        phone: phone || decoded.phone_number || null,
        firebaseUid: decoded.uid,
      });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });

    res.json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        membershipType: user.membershipType,
        membershipExpiry: user.membershipExpiry,
        isVIP: user.isVIP,
        totalBookings: user.totalBookings,
        enrolledCourses: user.enrolledCourses,
        role: user.role,
      },
    });
  } catch (error) {
    res.status(401).json({ success: false, message: 'Firebase authentication failed: ' + error.message });
  }
};

// ─── Get Profile ──────────────────────────────────────────────────────────────
exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).populate('enrolledCourses.courseId', 'title thumbnail');
    res.json({ success: true, user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Update Profile ───────────────────────────────────────────────────────────
exports.updateProfile = async (req, res) => {
  try {
    const { name, phone } = req.body;
    const user = await User.findByIdAndUpdate(
      req.user._id,
      { name, phone },
      { new: true, runValidators: true }
    );
    res.json({ success: true, user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// ─── Update FCM Token ─────────────────────────────────────────────────────────
exports.updateFcmToken = async (req, res) => {
  try {
    const { fcmToken } = req.body;
    await User.findByIdAndUpdate(req.user._id, { fcmToken });
    res.json({ success: true, message: 'FCM token updated' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
