const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/paymentController');
const { verifyFirebaseToken, requireAdmin } = require('../middleware/auth');

// Generate QR (public - any user can get the QR)
router.get('/qr', ctrl.generateQR);

// Admin: verify manual payment and unlock course
router.post('/verify-course', verifyFirebaseToken, requireAdmin, ctrl.verifyCoursePayment);

module.exports = router;
