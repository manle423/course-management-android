const categoryService = require('../services/category');

/**
 * @route POST categories/
 * @desc Add a category
 * @access Public
 */
const createCategory = async (req, res, next) => {
  const { name } = req.body;
  try {
    const rs = await categoryService.createCategory(name);
    res.json(rs);
  } catch (error) {
    console.error('Error create category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET categories/
 * @desc Show all categories
 * @access Public
 */
const getAllCategories = async (req, res, next) => {
  try {
    const page = req.query.page;
    const categories = await categoryService.getAllCategories(page);
    res.json(categories);
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET categories/:id
 * @desc Get a category
 * @access Public
 */
const getCategoryById = async (req, res, next) => {
  try {
    const category = await categoryService.getCategoryById(req.params.id);
    res.json(category);
  } catch (error) {
    console.error('Error fetching category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  createCategory,
  getAllCategories,
  getCategoryById,
};
