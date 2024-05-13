const mysql = require('mysql2/promise');
const config = require('../../config');

async function callSpGetCourse(id) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(`CALL sp_search_course_by_id(?)`, [id]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
}

async function callSpGetAllCourses(offset, limitPerPage) {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_get_all_courses(?, ?)', [
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
  callSpGetAllCourses,
  callSpGetCourse,
};
