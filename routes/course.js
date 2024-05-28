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

// [GET:] search course by name
router.get('/search', courseController.searchCourses);

// [GET:] course by id
router.get('/:id', courseController.getCourse);

// [PUT:] update course by id
router.put(
  '/:id',
  verifyToken,
  checkRole([ROLES.MODERATOR]),
  courseController.updateCourse,
);

module.exports = router;
