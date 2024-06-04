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

const checkIsUserAttended = async (userId, courseId) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_check_is_user_attended(?,?)`, [
      userId,
      courseId,
    ]);
    return rows[0][0];
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpDeleteOrder = async (userId, courseId) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_delete_order(?, ?)`, [
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

const callSpSortByPopularityDesc = async () => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_sort_by_popularity_desc`);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpSortByPopularityAsc = async () => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_sort_by_popularity_asc`);
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
  checkIsUserAttended,
  callSpDeleteOrder,
  callSpSortByPopularityDesc,
  callSpSortByPopularityAsc,
};
