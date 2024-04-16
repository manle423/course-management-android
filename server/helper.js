// Người giúp việc trong nhà

function getOffset(currentPage = 1, listPerPage = 1) {
    return (currentPage - 1) * listPerPage;
}

function emptyOrRows(rows) {
    if (!rows) {
        return [];
    }
    return rows;
}

module.exports = {
    getOffset,
    emptyOrRows,
};
