const jwt = require("jsonwebtoken");
require("dotenv").config(); 

const verifyToken = (req, res, next) => {
  // const token = req.headers.authorization;
  const { token } = req.body; 
  console.log("Token:", token);
  if (!token) {
    return res.status(401).json({ error: "Unauthorized: Missing token" });
  }
  try {
    console.log("Secret:", secret);
    const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
    // const decoded = jwt.decode(token);
    console.log("Decoded:", decoded);
    req.user = decoded;
    
    next();
  } catch (error) {
    return res.status(403).json({ error: "Forbidden: Invalid token" });
  }
};

module.exports = { verifyToken };
