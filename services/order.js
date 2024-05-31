const db = require("./databases");
const helper = require("../helper");
const config = require("../config");

const createOrder = async (user_id, course_id) => {
  const id = helper.generateUUID();
  try {
    const rows = await db.order.callSpCreateOrder(id, user_id, course_id);
    const data = helper.emptyOrRows(rows);
    if (data.affectedRows > 0) {
      return {
        status: "success",
        data: data,
      };
    }
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const getOrderByUserId = async (user_id) => {
  try {
    const rows = await db.order.callSpGetOrderByUserId(user_id);
    const data = helper.emptyOrRows(rows);
    console.log(data);
    return data;
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const checkIsUserAttended = async (user_id, course_id) => {
  try {
    const rows = await db.order.checkIsUserAttended(user_id, course_id);
    const data = helper.emptyOrRows(rows);
    return data;
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const deleteOrder = async (user_id, course_id) => {
  try {
    const rows = await db.order.callSpDeleteOrder(user_id, course_id);
    const data = helper.emptyOrRows(rows);
    if (data.affectedRows > 0) {
      return {
        status: "success",
        data: data,
      };
    } else {
      return {
        status: "error",
        data: data,
      };
    }
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

module.exports = {
  createOrder,
  getOrderByUserId,
  checkIsUserAttended,
  deleteOrder,
};
