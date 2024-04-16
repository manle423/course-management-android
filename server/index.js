const express = require('express');
const app = express();
const port = 3000;
const host = 'localhost';
const route = require('./routes');

//#region Routes
route(app);
//#endregion

//#region Middleware

//parse JSON
app.use(express.json());
app.use(
  express.urlencoded({
    extended: true,
  }),
);
//handler error
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  console.error(err.message, err.stack);
  res.status(statusCode).json({
    message: err.message,
  });
  return;
});
//#endregion

app.listen(port, () => {
  console.log(`App running on http://${host}:${port}`);
});
