const orderService = require('../services/order');

/**
 * @route POST orders/
 * @desc Add an order
 * @access Private
 */
const createOrder = async (req, res, next) => {
  const { user_id, course_id } = req.body;

  try {
    const rs = await orderService.createOrder(user_id, course_id);
    res.json(rs);
  } catch (error) {
    next(error);
  }
};

/**
 * @route GET orders/:id
 * @desc get all orders of user
 * @access Private
 */
const getOrderByUserId = async (req, res, next) => {
  try {
    const rs = await orderService.getOrderByUserId(req.params.id);
    console.log(rs[0]);
    res.json(rs[0]);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createOrder,
  getOrderByUserId,
};
