const db = require('./databases');
const helper = require('../helper');
const config = require('../config');

const createRole = async (name) => {
  try {
    const rows = await db.role.callSpCreateRole(name);
    const data = helper.emptyOrRows(rows);
    return { status: 'success', data: data };
  } catch (error) {
    return { status: 'error', error: error.message };
  }
};

const getAllRoles = async (page = 1) => {
  const offSet = helper.getOffset(page, config.listPerPage);
  const [rows] = await db.role.callSpGetAllRoles(offSet, config.listPerPage);
  const data = helper.emptyOrRows(rows);
  return data;
};

module.exports = {
  createRole,
  getAllRoles,
};
