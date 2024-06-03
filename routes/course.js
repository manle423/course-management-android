const express = require('express');
const router = express.Router();
const courseController = require('../controllers/course');
const {
  verifyToken,
  checkRole,
  ROLES,
} = require('../middlewares/authMiddleware');

// [GET:] all courses
router.get('/', courseController.getAllCourses);

// [POST:] create course with jwt token
router.post(
  '/',
  verifyToken,
  checkRole([ROLES.MODERATOR]),
  courseController.createCourse,
);

router.get('/total_courses', courseController.getTotalCourses);

// [GET:] search course by name
router.get('/search', courseController.searchCourses);

// [PUT:] update course by id
router.put(
  '/:id',
  verifyToken,
  checkRole([ROLES.MODERATOR]),
  courseController.updateCourse,
);

// [GET:] Get list of courses sorted by popularity
router.get('/popular', courseController.getPopularCourses);

// [GET:] course by id
router.get('/:id', courseController.getCourse);

module.exports = router;
