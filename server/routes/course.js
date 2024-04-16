const express = require('express');
const router = express.Router();
const courseService = require('../services/course');

// [GET:] all courses
router.get('/', async (req, res, next) => {
  try {
    const page = req.query.page;
    const courses = await courseService.getAllCourse(page);
    res.json(courses);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    const course = await courseService.search(req.params.id);
    res.json(course);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
module.exports = router;
