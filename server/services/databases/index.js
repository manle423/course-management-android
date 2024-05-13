const mysql = require('mysql2/promise');
const config = require('../../config');
const category = require('./category');
const course = require('./course');
const user = require('./user');

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

module.exports = {
  query,
  category,
  course,
  user,
};
