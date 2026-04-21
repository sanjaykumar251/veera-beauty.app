const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/membershipController');
const { verifyFirebaseToken, optionalAuth, requireAdmin } = require('../middleware/auth');

router.get('/plan', optionalAuth, ctrl.getVIPPlan);
router.get('/my', verifyFirebaseToken, ctrl.getMyMembership);
router.post('/activate', verifyFirebaseToken, requireAdmin, ctrl.activateVIP);

module.exports = router;
