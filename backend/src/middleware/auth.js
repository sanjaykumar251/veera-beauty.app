const admin = require('../config/firebase');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

const resolveAuthenticatedUser = async (token) => {
  if (!token) {
    return { user: null, firebaseUser: null };
  }

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    const user = await User.findOne({ firebaseUid: decoded.uid });
    if (user && user.isActive) {
      return { user, firebaseUser: decoded };
    }
  } catch (firebaseErr) {
    // Fall back to JWT below.
  }

  const decoded = jwt.verify(token, process.env.JWT_SECRET);
  const user = await User.findById(decoded.id);

  if (!user || !user.isActive) {
    throw new Error('User not found or deactivated');
  }

  return { user, firebaseUser: null };
};

// ─── Verify Firebase Token ────────────────────────────────────────────────────
const verifyFirebaseToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, message: 'No token provided' });
    }

    const token = authHeader.split(' ')[1];
    const { user, firebaseUser } = await resolveAuthenticatedUser(token);
    req.user = user;
    req.firebaseUser = firebaseUser;
    return next();
  } catch (error) {
    return res.status(401).json({ success: false, message: 'Invalid or expired token' });
  }
};

// ─── Optional Auth (doesn't fail if no token) ────────────────────────────────
const optionalAuth = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    req.user = null;
    req.firebaseUser = null;
    return next();
  }

  try {
    const token = authHeader.split(' ')[1];
    const { user, firebaseUser } = await resolveAuthenticatedUser(token);
    req.user = user;
    req.firebaseUser = firebaseUser;
  } catch {
    req.user = null;
    req.firebaseUser = null;
  }

  return next();
};

// ─── Require Admin ────────────────────────────────────────────────────────────
const requireAdmin = (req, res, next) => {
  if (!req.user || req.user.role !== 'admin') {
    return res.status(403).json({ success: false, message: 'Admin access required' });
  }
  next();
};

// ─── Require VIP ──────────────────────────────────────────────────────────────
const requireVIP = (req, res, next) => {
  if (!req.user || !req.user.isVIP) {
    return res.status(403).json({ success: false, message: 'VIP membership required' });
  }
  next();
};

module.exports = { verifyFirebaseToken, optionalAuth, requireAdmin, requireVIP };
