const jwt = require("jsonwebtoken");
require("dotenv").config();

const ROLES = {
  ADMIN: 1,
  MODERATOR: 2,
  USER: 3,
};

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

const checkRole = (allowedRoles) => (req, res, next) => {
  if (!req.user || !allowedRoles.includes(req.user.role_id)) {
    return res.status(403).json({ error: "Forbidden: Access denied" });
  }
  next();
};

const checkUserOrAdmin = (req, res, next) => {
  const userId = req.params.id;
  if (req.user.role_id === ROLES.ADMIN || req.user.userId === userId) {
    return next();
  } else {
    return res.status(403).json({ error: "Forbidden: Access denied" });
  }
};

const checkIsThatUser = (req, res, next) => {
  const userId = req.params.id;
  if (req.user.userId === userId) {
    return next();
  } else {
    return res.status(403).json({ error: "Forbidden: Access denied" });
  }
};

const decodeToken = (token) => {
  const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
  return decoded;
};

module.exports = {
  verifyToken,
  extractToken,
  checkRole,
  checkUserOrAdmin,
  checkIsThatUser,
  decodeToken,
  ROLES,
};
