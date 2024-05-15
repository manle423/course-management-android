const express = require('express');
const router = express.Router();
const categoryService = require('../services/category');

// [POST:] create category
router.post('/', async (req, res, next) => {
  const { name } = req.body;
  try {
    const rs = await categoryService.createCategory(name);
    res.json(rs);
  } catch (error) {
    console.error('Error create category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// [GET:] all categories
router.get('/', async (req, res, next) => {
  try {
    const page = req.query.page;
    const categories = await categoryService.getAllCategories(page);
    res.json(categories);
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// [GET:] category by id
router.get('/:id', async (req, res, next) => {
  try {
    const category = await categoryService.getCategoryById(req.params.id);
    res.json(category);
  } catch (error) {
    console.error('Error fetching category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
