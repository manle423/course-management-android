const db = require('./db');
const helper = require('../helper');
const config = require('../config');

async function getAllCategories(page = 1) {
  const offSet = helper.getOffset(page, config.listPerPage);
  const [rows] = await db.callSpGetAllCategories(offSet, config.listPerPage);
  const data = helper.emptyOrRows(rows);
  return data;
}

async function getCategoryById(id) {
  const [rows] = await db.callSpGetCategory(id);
  const data = helper.emptyOrRows(rows);
  return data;
}

module.exports = {
  getAllCategories,
  getCategoryById,
};
