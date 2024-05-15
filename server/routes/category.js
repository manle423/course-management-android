const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/category');

// [POST:] create category
router.post('/', categoryController.createCategory);

// [GET:] all categories
router.get('/', categoryController.getAllCategories);

// [GET:] category by id
router.get('/:id', categoryController.getCategoryById);

module.exports = router;
