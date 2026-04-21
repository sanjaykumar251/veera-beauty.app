const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/bookingController');
const { verifyFirebaseToken, optionalAuth, requireAdmin } = require('../middleware/auth');

// Guest or logged-in booking
router.post('/', optionalAuth, ctrl.createBooking);

// Logged-in only
router.get('/my', verifyFirebaseToken, ctrl.getMyBookings);
router.get('/:id', verifyFirebaseToken, ctrl.getBooking);
router.put('/:id/cancel', verifyFirebaseToken, ctrl.cancelBooking);

// Admin
router.get('/', verifyFirebaseToken, requireAdmin, ctrl.getAllBookings);
router.put('/:id/status', verifyFirebaseToken, requireAdmin, ctrl.updateBookingStatus);

module.exports = router;
