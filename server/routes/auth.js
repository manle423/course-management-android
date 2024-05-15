const express = require("express");
const router = express.Router();
const authService = require("../services/auth");

// [POST:] create a new user
router.post("/register", async (req, res, next) => {
  const { username, password, retypePassword } = req.body;
  try {
    const rs = await authService.register(username, password, retypePassword);
    res.json(rs);
  } catch (error) {
    console.error("Error create user:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// [POST:] login
router.post("/login", async (req, res, next) => {
  const { username, password } = req.body;
  try {
    const token = await authService.login(username, password);
    res.json({ token });
  } catch (error) {
    console.error("Error during login:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
