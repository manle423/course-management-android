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
    console.log(rs);
  } catch (error) {
    console.error('Error creating course:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET courses/total_course
 * @desc total of courses
 * @access Public
 */
const getTotalCourses = async (req, res, next) => {
  try {
    const rs = await courseService.getTotalCourses();
    res.json(rs);
  } catch (error) {
    console.error('Error fetching courses:', error);
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
 * @route GET courses ?search=
 * @desc Search course by description or name
 * @access Public
 */
const searchCourses = async (req, res, next) => {
  // console.log(req.query.searchTerm);
  try {
    // const searchTerm = req.params.body.search;
    const searchTerm = req.query.searchTerm;
    console.log(searchTerm);
    if (!searchTerm) {
      return res.status(400).json({ message: 'Please provide a search term' });
    }
    const condition = req.query.condition;
    if (!condition) {
      const courses = await courseService.searchCourses(searchTerm);
      res.json(courses);
    } else {
      const courses =
        await courseService.searchCoursesWithImageAndVideo(searchTerm);
      res.json(courses);
    }
    // console.log(`Searching courses for: ${searchTerm}`); // Log the search term
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route PUT courses/:id
 * @desc Update a single course (only moderator allowed)
 * @access Private
 */
const updateCourse = async (req, res, next) => {
  const { name, description, image, video, category_id } = req.body;
  const courseId = req.params.id;

  try {
    const rs = await courseService.updateCourse(
      courseId,
      name,
      description,
      image,
      video,
      category_id,
    );
    res.json(rs);
    console.log('Updated successfully');
  } catch (error) {
    console.error('Error updating course:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET /courses/popular?sort=
 * @desc Get list of courses sorted by popularity
 * @query {string} [sort] - 'asc' or 'desc'
 * @access Public
 */
const getPopularCourses = async (req, res, next) => {
  try {
    const sort = req.query.sort;
    const category_id = req.query.category_id;
    console.log(category_id);
    console.log(sort);
    if (typeof category_id === 'undefined' || category_id === '') {
      const rs = await courseService.getPopularCourses(sort);
      res.json(rs);
    } else {
      const rs = await courseService.searchByCategory(sort, category_id);
      res.json(rs);
    }
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
  updateCourse,
  getTotalCourses,
  getPopularCourses,
};
