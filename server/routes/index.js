const courseRouter = require('./course');
const categoryRouter = require('./category');

function route(app) {
  app.use('/courses', courseRouter);

  app.use('/categories', categoryRouter);
}

module.exports = route;
