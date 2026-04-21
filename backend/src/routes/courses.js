const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/courseController');
const { verifyFirebaseToken, optionalAuth, requireAdmin } = require('../middleware/auth');

// Public (hides video IDs if not enrolled)
router.get('/', optionalAuth, ctrl.getCourses);
router.get('/my', verifyFirebaseToken, ctrl.getMyCourses);
router.get('/:id', optionalAuth, ctrl.getCourse);

// Progress (enrolled users only)
router.put('/progress', verifyFirebaseToken, ctrl.updateProgress);

// Admin
router.post('/', verifyFirebaseToken, requireAdmin, ctrl.createCourse);
router.put('/:id', verifyFirebaseToken, requireAdmin, ctrl.updateCourse);
router.delete('/:id', verifyFirebaseToken, requireAdmin, ctrl.deleteCourse);
router.post('/:id/modules', verifyFirebaseToken, requireAdmin, ctrl.addModule);
router.post('/:courseId/modules/:moduleId/lessons', verifyFirebaseToken, requireAdmin, ctrl.addLesson);

module.exports = router;
