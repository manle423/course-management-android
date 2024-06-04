const orderService = require('../services/order');
const { extractToken, decodeToken } = require('../middlewares/authMiddleware');

/**
 * @route POST orders/
 * @desc Add an order
 * @access Private
 */
const createOrder = async (req, res, next) => {
  const token = extractToken(req);
  const { userId } = decodeToken(token);
  const { course_id } = req.body;
  // console.log(userId);

  try {
    const rs = await orderService.createOrder(userId, course_id);
    res.json(rs);
  } catch (error) {
    next(error);
  }
};

/**
 * @route GET orders/attended
 * @desc get all orders of user
 * @access Private
 */
const getOrderByUserId = async (req, res, next) => {
  const token = extractToken(req);
  const { userId } = decodeToken(token);
  try {
    const rs = await orderService.getOrderByUserId(userId);
    console.log(rs[0]);
    res.json(rs[0]);
  } catch (error) {
    next(error);
  }
};

/**
 * @route GET orders/check
 * @desc check if the user attended course
 * @access Private
 */
const checkIsUserAttended = async (req, res, next) => {
  const token = extractToken(req);
  const { userId } = decodeToken(token);
  const { course_id } = req.body;
  console.log('userId: ' + userId);
  console.log('course_id: ' + course_id);
  try {
    const rs = await orderService.checkIsUserAttended(userId, course_id);
    console.log(rs);
    res.json(rs);
  } catch (error) {
    next(error);
  }
};

/**
 * @route DELETE orders/delete
 * @desc delete order by userid and courseid
 * @access Private
 */
const deleteOrder = async (req, res, next) => {
  const token = extractToken(req);
  const { userId } = decodeToken(token);
  const course_id = req.params.id;
  console.log(course_id);
  try {
    const rs = await orderService.deleteOrder(userId, course_id);
    res.json(rs);
  } catch (error) {
    next(error);
  }
};

/**
 * @route GET orders/sortasc
 * @desc sort the popular courses asc
 * @access Public
 */
const sortByPopularityAsc = async (req, res, next) => {
  try {
    const rs = await orderService.sortByPopularityAsc();
    res.json(rs);
  } catch (error) {
    next(error);
  }
};

/**
 * @route GET orders/sortdesc
 * @desc sort the popular courses desc
 * @access Public
 */
const sortByPopularityDesc = async (req, res, next) => {
  try {
    const rs = await orderService.sortByPopularityDesc();
    res.json(rs);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createOrder,
  getOrderByUserId,
  checkIsUserAttended,
  deleteOrder,
  sortByPopularityAsc,
  sortByPopularityDesc,
};
