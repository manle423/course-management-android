const express = require('express');
const router = express.Router();
const orderController = require('../controllers/order');
const {
  verifyToken,
  checkIsThatUser,
} = require('../middlewares/authMiddleware');

// [POST:] create order
router.post('/', verifyToken, orderController.createOrder);

// [GET:] Get order of userId
router.get(
  '/:id',
  verifyToken,
  checkIsThatUser,
  orderController.getOrderByUserId,
);

module.exports = router;
