const mysql = require('mysql2/promise');
const config = require('../../config');

const callSpCreateCourse = async (
  id,
  name,
  description,
  image,
  video,
  category_id,
) => {
  let conn;
  // console.log(id);
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(
      `CALL sp_create_course(?, ?, ?, ?, ?, ?)`,
      [id, name, description, image, video, category_id],
    );
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
};

const callSpGetCourse = async (id) => {
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
};

const callSpGetAllCourses = async (offset, limitPerPage) => {
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
};

const callSpSearchCourses = async (searchTerm) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_search_course(?)', [searchTerm]);
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
  callSpCreateCourse,
  callSpGetAllCourses,
  callSpGetCourse,
  callSpSearchCourses,
};
