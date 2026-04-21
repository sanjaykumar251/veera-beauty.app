const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/serviceController');
const { verifyFirebaseToken, requireAdmin } = require('../middleware/auth');

// Public
router.get('/', ctrl.getServices);
router.get('/:id', ctrl.getService);

// Admin only
router.post('/', verifyFirebaseToken, requireAdmin, ctrl.createService);
router.put('/:id', verifyFirebaseToken, requireAdmin, ctrl.updateService);
router.delete('/:id', verifyFirebaseToken, requireAdmin, ctrl.deleteService);
router.post('/seed/default', verifyFirebaseToken, requireAdmin, ctrl.seedServices);

module.exports = router;
