const express = require('express');
const router = express.Router();
const roleController = require('../controllers/role');
const {
  verifyToken,
  checkRole,
  ROLES,
} = require('../middlewares/authMiddleware');

router.post(
  '/',
  verifyToken,
  checkRole([ROLES.ADMIN]),
  roleController.createRole,
);

router.get('/', roleController.getAllRoles);

module.exports = router;
