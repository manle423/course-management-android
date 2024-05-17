const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/category');
const { verifyToken, checkRole, ROLES } = require('../middlewares/authMiddleware');

// [POST:] create category
router.post('/', verifyToken, checkRole([ROLES.MODERATOR]), categoryController.createCategory);

// [GET:] all categories
router.get('/', categoryController.getAllCategories);

// [GET:] category by id
router.get('/:id', categoryController.getCategoryById);

module.exports = router;
