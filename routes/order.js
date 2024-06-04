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
router.get('/attended', verifyToken, orderController.getOrderByUserId);

// [GET:] check if user attended course
router.post('/check', verifyToken, orderController.checkIsUserAttended);

// [DELETE:] delete order by userId and courseId
router.delete('/delete/:id', verifyToken, orderController.deleteOrder);

// [GET] Sort courses by popularity in descending order
router.get('/sortdesc', orderController.sortByPopularityDesc);

// [GET] Sort courses by popularity in ascending order
router.get('/sortasc', orderController.sortByPopularityAsc);

module.exports = router;
