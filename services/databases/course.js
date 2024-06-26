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

const callSpGetTotalCourses = async () => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_get_total_courses()');
    console.log(rows);
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
const callSpSearchCoursesWithImageAndVideo = async (searchTerm) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute(
      'CALL sp_search_with_image_and_video(?)',
      [searchTerm],
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

const callSpUpdateCourse = async (
  id,
  name,
  description,
  image,
  video,
  category_id,
) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_update_course(?,?,?,?,?,?)', [
      id,
      name,
      description,
      image,
      video,
      category_id,
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

const callSpGetPopularCourses = async (sort) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_sort_by_popularity(?)', [sort]);
    return rows;
  } catch (error) {
    throw error;
  } finally {
    if (conn) {
      conn.end();
    }
  }
};

const callSpSearchByCategory = async (sort, category_id) => {
  let conn;
  try {
    conn = await mysql.createConnection(config.db);
    const [rows] = await conn.execute('CALL sp_search_by_category(?, ?)', [
      sort,
      category_id,
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
  callSpCreateCourse,
  callSpGetAllCourses,
  callSpGetCourse,
  callSpSearchCourses,
  callSpUpdateCourse,
  callSpGetTotalCourses,
  callSpGetPopularCourses,
  callSpSearchByCategory,
  callSpSearchCoursesWithImageAndVideo,
};
