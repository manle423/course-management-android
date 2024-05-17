const authService = require("../services/auth");
const { extractToken } = require("../middlewares/authMiddleware");

/**
 * @route POST auth/register
 * @desc Registers a user
 * @access Public
 */
const register = async (req, res, next) => {
  const { username, password, retypePassword } = req.body;
  try {
    const rs = await authService.register(username, password, retypePassword);
    res.json(rs);
  } catch (error) {
    console.error("Error create user:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

/**
 * @route POST auth/login
 * @desc Logs in a user
 * @access Public
 */
const login = async (req, res, next) => {
  const { username, password } = req.body;
  try {
    const token = await authService.login(username, password);
    res.json({ token });
  } catch (error) {
    console.error("Error during login:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

/**
 * @route POST auth/logout
 * @desc Log out a user
 * @access Public
 */
const logout = async (req, res, next) => {
  const token = extractToken(req);
  // console.log(token);
  try {
    const rs = await authService.logout(token);
    res.json(rs);
  } catch (error) {
    console.error("Error during logout:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = {
  register,
  login,
  logout,
};
