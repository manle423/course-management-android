const db = require('./db');
const helper = require('../helper');
const config = require('../config');

        async function getAllCourse(page = 1) {
  const offSet = helper.getOffset(page, config.listPerPage);
  const sql = `SELECT * FROM COURSES LIMIT ${offSet}, ${config.listPerPage}`;
  const row = await db.query(sql);
  const data = helper.emptyOrRows(row);
  return data;
}

async function search(id) {
  const sql = `SELECT * FROM COURSES WHERE id = ?`;
  const values = [id];
  const [rows] = await db.query(sql, values); // Sử dụng parameterized query
  const data = helper.emptyOrRows(rows);
  return data;
}

module.exports = {
  getAllCourse,
  search,
};

