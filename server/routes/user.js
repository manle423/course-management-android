const express = require('express');
const router = express.Router();
const userService = require('../services/user');

// [POST:] create a new user
router.post('/', async (req, res, next) => {
  const { username, password, retypePassword } = req.body;
  try {
    const rs = await userService.createUser(username, password, retypePassword);
    res.json(rs);
  } catch (error) {
    console.error('Error create user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// [GET:] get user by id


// [GET:] get all users
router.get('/', async (req, res, next) => {
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
});

// [PUT:] update user by id
// [DELETE:] delete user by id


module.exports = router;