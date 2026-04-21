const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/adminController');
const { verifyFirebaseToken, requireAdmin } = require('../middleware/auth');

router.use(verifyFirebaseToken, requireAdmin);

router.get('/dashboard', ctrl.getDashboard);
router.get('/users', ctrl.getUsers);
router.put('/users/:id', ctrl.updateUser);
router.post('/users/enroll', ctrl.enrollUserInCourse);
router.post('/notify', ctrl.sendNotification);

module.exports = router;
