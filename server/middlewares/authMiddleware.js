const jwt = require("jsonwebtoken");
require("dotenv").config();

const verifyToken = (req, res, next) => {
  // const token = req.headers.authorization;
  // const TokenArray = token.split(" ");

  const token = extractToken(req);
  // console.log("token extract function:", extractToken(req));
  if (!token) {
    return res.status(401).json({ error: "Unauthorized: Missing token" });
  }
  try {
    const data = jwt.verify(token, process.env.JWT_SECRET_KEY);
    // console.log("data:", data);
    req.user = data;
    next();
  } catch (error) {
    return res.status(403).json({ error: "Forbidden: Invalid token" });
  }
};

const extractToken = (req) => {
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer ")
  ) {
    return req.headers.authorization.substring(7);
  }
  return null;
};

module.exports = { verifyToken };
