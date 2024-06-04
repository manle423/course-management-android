const db = require("./databases");
const helper = require("../helper");
const config = require("../config");

const getAllCourses = async (page = 1) => {
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

const getTotalCourses = async () => {
  const [rows] = await db.course.callSpGetTotalCourses();
  const data = helper.emptyOrRows(rows);
  return data;
};

const createCourse = async (name, description, image, video, category_id) => {
  const id = helper.generateUUID();
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
    if (data.affectedRows > 0) {
      return {
        status: "success",
        data: data,
      };
    }
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const getCourse = async (id) => {
  const [rows] = await db.course.callSpGetCourse(id);
  const data = helper.emptyOrRows(rows);
  return data;
};

const searchCourses = async (searchTerm) => {
  console.log(searchTerm);
  const [rows] = await db.course.callSpSearchCourses(searchTerm);
  const data = helper.emptyOrRows(rows);
  return data;
};
const searchCoursesWithImageAndVideo = async (searchTerm) => {
  const [rows] =
    await db.course.callSpSearchCoursesWithImageAndVideo(searchTerm);
  const data = helper.emptyOrRows(rows);
  console.log(data);
  return data;
};

const updateCourse = async (
  id,
  name,
  description,
  image,
  video,
  category_id
) => {
  try {
    const rows = await db.course.callSpUpdateCourse(
      id,
      name,
      description,
      image,
      video,
      category_id
    );
    const data = helper.emptyOrRows(rows);
    if (data.affectedRows > 0) {
      return {
        status: "success",
        data: data,
      };
    }
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const getPopularCourses = async (sort) => {
  console.log(sort);
  const [rows] = await db.course.callSpGetPopularCourses(sort);
  const data = helper.emptyOrRows(rows);
  return data;
};

module.exports = {
  createCourse,
  getAllCourses,
  getCourse,
  searchCourses,
  updateCourse,
  getTotalCourses,
  getPopularCourses,
};
