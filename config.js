const config = {
  db: {
    host: 'localhost',
    user: 'root',
    password: 'mysql',
    database: 'lms-android',
    connectTimeout: 60000,
    multipleStatements: true,
  },
  listPerPage: 10,
};
module.exports = config;