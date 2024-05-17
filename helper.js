// Người giúp việc trong nhà helper.js
const { v4: uuidv4 } = require('uuid');

const generateUUID = () => {
  return uuidv4();
}

const getOffset = (currentPage = 1, listPerPage = 1) => {
  return (currentPage - 1) * listPerPage;
}

const emptyOrRows = (rows) => {
  if (!rows) {
    return [];
  }
  return rows;
}

module.exports = {
  generateUUID,
  getOffset,
  emptyOrRows,
};
