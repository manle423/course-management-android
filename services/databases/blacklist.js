const mysql = require('mysql2/promise');
const config = require('../../config');

const callSpAddToBlacklist = async (token) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_add_to_blacklist(?)`, [token]);
    console.log(rows);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const checkTokenInBlacklist = async (token) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_check_token_in_blacklist(?)`, [
      token,
    ]);
    const rs = rows[0][0].token_exists == 0 ? false : true;
    // console.log(rs);
    return rs;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

module.exports = {
  callSpAddToBlacklist,
  checkTokenInBlacklist,
};
