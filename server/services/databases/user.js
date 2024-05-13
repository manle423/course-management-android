const mysql = require('mysql2/promise');
const config = require('../../config');

async function callSpCreateUser(id, username, password) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_create_user(?, ?, ?)`, [
      id,
      username,
      password,
    ]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

async function checkUsernameExists(username) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_check_username_exists(?)`, [
      username,
    ]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

async function callSpGetAllUsers(offset, limitPerPage) {
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
      conn.end();
    }
  }
}

module.exports = {
  callSpCreateUser,
  checkUsernameExists,
  callSpGetAllUsers,
};
