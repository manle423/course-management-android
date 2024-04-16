const courseRouter = require('./course');

function route(app) {
    app.use('/course', courseRouter);
}

module.exports = route;
