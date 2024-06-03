const mysql = require('mysql2/promise');
const config = require('../../config');
const db = require('./index');

const callSpCreateUser = async (id, email, username, password) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_create_user(?, ?, ?, ?)`, [
      id,
      email,
      username,
      password,
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

const checkUsernameExists = async (username) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_check_username_exists(?)`, [
      username,
    ]);
    return rows[0][0].username_available;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpGetAllUsers = async (offset, limitPerPage) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_get_all_users(?, ?)', [
      offset,
      limitPerPage,
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

const callSpGetUser = async (id) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_search_user_by_id(?)', [id]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const checkUserIsAdmin = async (id) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_check_is_admin(?)`, [id]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const checkUserIsActive = async (id) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_check_is_active(?)`, [id]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpGetUserByUsername = async (username) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_search_user_by_username(?)', [
      username,
    ]);
    return rows[0];
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpChangeInfo = async (id, full_name) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_change_info(?, ?)', [
      id,
      full_name,
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
  callSpCreateUser,
  checkUsernameExists,
  callSpGetAllUsers,
  callSpGetUser,
  checkUserIsAdmin,
  checkUserIsActive,
  callSpGetUserByUsername,
  callSpChangeInfo,
};
