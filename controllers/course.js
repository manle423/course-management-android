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
    console.log('GetAllCourse');
    console.log('----------------------');
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

/**
 * @route GET courses/search?key=
 * @desc Search course by description or name
 * @access Public
 */
const searchCourses = async (req, res, next) => {
  console.log(req.query.searchTerm);
  try {
    // const searchTerm = req.params.body.search;
    const searchTerm = req.query.searchTerm;
    console.log(searchTerm);
    if (!searchTerm) {
      return res.status(400).json({ message: 'Please provide a search term' });
    }

    console.log(`Searching courses for: ${searchTerm}`); // Log the search term

    const courses = await courseService.searchCourses(searchTerm);
    res.json(courses);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  createCourse,
  getAllCourses,
  getCourse,
  searchCourses,
};
