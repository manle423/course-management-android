const mysql = require('mysql2/promise');
const config = require('../config');

async function query(sql, params) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(sql, params);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

async function callSpSearch(id) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_search_book_by_id(?)`, [id]);
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
  query,
  callSpSearch,
};
