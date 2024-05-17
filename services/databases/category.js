const mysql = require('mysql2/promise');
const config = require('../../config');

const callSpCreateCategory = async(name) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_create_category(?)`, [name]);
    return rows;
  } catch (error) {
      throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
}

const callSpGetAllCategories = async(offset, limitPerPage) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_get_all_categories(?, ?)', [
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
}

const callSpGetCategory = async(id) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_search_category_by_id(?)`, [id]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
}

module.exports = {
  callSpCreateCategory,
  callSpGetAllCategories,
  callSpGetCategory,
};
