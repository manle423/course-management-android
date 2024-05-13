const mysql = require('mysql2/promise');
const config = require('../../config');

async function callSpGetAllCategories(offset, limitPerPage) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_get_all_categories(?, ?)', [offset, limitPerPage]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

async function callSpGetCategory(id) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_search_category_by_id(?)`, [id]);
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
  callSpGetAllCategories,
  callSpGetCategory,
};
