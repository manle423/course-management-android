const mysql = require('mysql2/promise');
const config = require('../../config');

const callSpCreateOrder = async (id, userId, courseId) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_create_order(?, ?, ?)`, [
      id,
      userId,
      courseId,
    ]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpGetOrderByUserId = async (userId) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_get_order_by_user_id(?)`, [
      userId,
    ]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

module.exports = {
  callSpCreateOrder,
  callSpGetOrderByUserId,
};
