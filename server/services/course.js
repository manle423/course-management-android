const db = require("./databases");
const helper = require("../helper");
const config = require("../config");
const { v4: uuidv4 } = require('uuid');

const getAllCourse = async (page = 1) => {
  // const offSet = helper.getOffset(page, config.listPerPage);
  // const sql = `SELECT * FROM COURSES LIMIT ${offSet}, ${config.listPerPage}`;
  // const row = await db.query(sql);
  // const data = helper.emptyOrRows(row);
  // return data;
  const offSet = helper.getOffset(page, config.listPerPage);
  const [rows] = await db.course.callSpGetAllCourses(
    offSet,
    config.listPerPage
  );
  const data = helper.emptyOrRows(rows);
  return data;
};

const createCourse = async (name, description, image, video, category_id) => {
  const id = uuidv4();
  try {
    const rows = await db.course.callSpCreateCourse(
      id,
      name,
      description,
      image,
      video,
      category_id
    );
    const data = helper.emptyOrRows(rows);
    return { status: "success", data: data };
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const getCourse = async (id) => {
  const [rows] = await db.course.callSpGetCourse(id);
  const data = helper.emptyOrRows(rows);
  return data;
};

module.exports = {
  createCourse,
  getAllCourse,
  getCourse,
};
