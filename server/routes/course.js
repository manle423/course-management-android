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

router.post('/', async (req, res, next) => {
  const { name, description, image, video, category_id } = req.body;
  console.log(req.body);
  try {
    const rs = await courseService.createCourse(name, description, image, video, category_id);
    res.json(rs);
  } catch (error) {
    console.error('Error create user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// [GET:] course by id
router.get('/:id', async (req, res, next) => {
  try {
    const course = await courseService.getCourse(req.params.id);
    res.json(course);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
