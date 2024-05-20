const mysql = require('mysql2/promise');
const config = require('../../config');

const callSpCreateRole = async (name) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_create_role(?)`, [name]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      await conn.end();
    }
  }
};

const callSpGetAllRoles = async (offset, limitPerPage) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_get_all_roles(?, ?)', [
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
};

module.exports = {
  callSpCreateRole,
  callSpGetAllRoles,
};
