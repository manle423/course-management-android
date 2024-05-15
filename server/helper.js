// Người giúp việc trong nhà

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
  getOffset,
  emptyOrRows,
};
