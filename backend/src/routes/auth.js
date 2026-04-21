const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/authController');
const { verifyFirebaseToken } = require('../middleware/auth');

router.post('/register', ctrl.register);
router.post('/login', ctrl.login);
router.post('/firebase', ctrl.firebaseAuth);
router.get('/profile', verifyFirebaseToken, ctrl.getProfile);
router.put('/profile', verifyFirebaseToken, ctrl.updateProfile);
router.put('/fcm-token', verifyFirebaseToken, ctrl.updateFcmToken);

module.exports = router;
