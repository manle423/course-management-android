const userService = require('../services/user');

/**
 * @route GET users/
 * @desc Get information of all users just admin
 * @access Private
 */
const getAllUsers = async (req, res, next) => {
  try {
    const page = req.query.page;
    const users = await userService.getAllUsers(page);
    // const filteredUserData = {
    //   id: users.id,
    //   username: users.username,
    // };
    res.json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET users/:id
 * @desc Get user information, admin or that user
 * @access Private
 */
const getUser = async (req, res, next) => {
  try {
    const user = await userService.getUser(req.params.id);
    res.json(user);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

const changeInfo = async (req, res, next) => {
  const { full_name } = req.body;
  try {
    const user = await userService.changeInfo(req.params.id, full_name);
    if (user.affectedRows > 0) {
      res.status(200).json([{ message: 'Change info success' }]);
    }
  } catch (error) {
    console.error('Error change info user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  getAllUsers,
  getUser,
  changeInfo,
};
