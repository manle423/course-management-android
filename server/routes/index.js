const authRouter = require("./auth");
const categoryRouter = require("./category");
const courseRouter = require("./course");
const orderRouter = require("./order");
const roleRouter = require("./role");
const userRouter = require("./user");

const route = (app) => {
  app.use("/auth", authRouter);
  app.use("/categories", categoryRouter);
  app.use("/courses", courseRouter);
  app.use("/orders", orderRouter);
  app.use("/roles", roleRouter);
  app.use("/users", userRouter);
};

module.exports = route;
