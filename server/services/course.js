const db = require('./databases');
const helper = require('../helper');
const config = require('../config');

async function getAllCourse(page = 1) {
  // const offSet = helper.getOffset(page, config.listPerPage);
  // const sql = `SELECT * FROM COURSES LIMIT ${offSet}, ${config.listPerPage}`;
  // const row = await db.query(sql);
  // const data = helper.emptyOrRows(row);
  // return data;
  const offSet = helper.getOffset(page, config.listPerPage);
  const [rows] = await db.course.callSpGetAllCourses(
    offSet,
    config.listPerPage,
  );
  const data = helper.emptyOrRows(rows);
  return data;
}

async function getCourse(id) {
  const [rows] = await db.course.callSpGetCourse(id);
  const data = helper.emptyOrRows(rows);
  return data;
}

module.exports = {
  getAllCourse,
  getCourse,
};
