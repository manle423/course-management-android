const db = require("./databases");
const helper = require("../helper");
const config = require("../config");

const createCategory = async (name) => {
  try {
    const rows = await db.category.callSpCreateCategory(name);
    const data = helper.emptyOrRows(rows);
    return { status: 'success', data: data };
  } catch (error) {
    return { status: 'error', error: error.message };
  }
};

const getAllCategories = async (page = 1) => {
  const offSet = helper.getOffset(page, config.listPerPage);
  const [rows] = await db.category.callSpGetAllCategories(
    offSet,
    config.listPerPage
  );
  const data = helper.emptyOrRows(rows);
  return data;
};

const getCategoryById = async (id) => {
  const [rows] = await db.category.callSpGetCategory(id);
  const data = helper.emptyOrRows(rows);
  return data;
};

module.exports = {
  createCategory,
  getAllCategories,
  getCategoryById,
};
