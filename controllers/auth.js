const authService = require('../services/auth');
const { extractToken } = require('../middlewares/authMiddleware');

/**
 * @route POST auth/register
 * @desc Registers a user
 * @access Public
 */
const register = async (req, res, next) => {
  const { username, email, password, retypePassword } = req.body;
  console.log('register', username, email, password);
  try {
    const rs = await authService.register(username, email, password, retypePassword);
    console.log(rs);
    res.json(rs);
  } catch (error) {
    console.error('Error create user:', error);
    res.status(500).json({ error: 'Internal server error' });
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
    console.log('Token', token);
    res.json({ token });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route POST auth/logout
 * @desc Log out a user
 * @access Public
 */
const logout = async (req, res, next) => {
  try {
    const token = extractToken(req);
    if (!token) {
      return res
        .status(400)
        .json({ status: 'error', message: 'Token not provided' });
    }
    const rs = await authService.logout(token);
    res.json(rs);
  } catch (error) {
    console.error('Error during logout:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  register,
  login,
  logout,
};
