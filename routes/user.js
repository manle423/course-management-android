const express = require("express");
const router = express.Router();
const userController = require("../controllers/user");
const { verifyToken, checkRole, checkUserOrAdmin, ROLES } = require('../middlewares/authMiddleware');

// [GET:] get user by id
router.get("/:id", verifyToken, checkUserOrAdmin, userController.getUser);

// [GET:] get all users
router.get("/", verifyToken, checkRole([ROLES.ADMIN]), userController.getAllUsers);

// [PUT:] update user by id
// [DELETE:] delete user by id

module.exports = router;
