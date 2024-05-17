const courseService = require('../services/course');

/**
 * @route POST courses/
 * @desc Add a course
 * @access Private
 */
const createCourse = async (req, res, next) => {
  const { name, description, image, video, category_id } = req.body;

  try {
    const rs = await courseService.createCourse(
      name,
      description,
      image,
      video,
      category_id,
    );
    res.json(rs);
  } catch (error) {
    console.error('Error creating course:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET courses/
 * @desc Show all courses
 * @access Public
 */
const getAllCourses = async (req, res, next) => {
  try {
    const page = req.query.page;
    const courses = await courseService.getAllCourses(page);
    res.json(courses);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET courses/:id
 * @desc Get course by id
 * @access Public
 */
const getCourse = async (req, res, next) => {
  try {
    const course = await courseService.getCourse(req.params.id);
    res.json(course);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  createCourse,
  getAllCourses,
  getCourse,
};
