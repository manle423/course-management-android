const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const route = require('./routes');

const port = 3000;
const host = 'localhost';

//#region Middleware

//parse JSON
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));

//handler error
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({
    status: err.statusCode,
    message: err.message,
  });
  return;
});

//#endregion

//#region Routes
route(app, express);
//#endregion

app.listen(port, () => {
  console.log(`App running on http://${host}:${port}`);
});
