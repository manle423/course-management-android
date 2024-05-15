const db = require('./databases');
const helper = require('../helper');
const config = require('../config');
const bcrypt = require('bcrypt');
const { v4: uuidv4 } = require('uuid');

// const { validationResult } = require("express-validator");
/*
async function createUser(username, password, retypePassword) {
  const id = uuidv4();
  try {
    const validationResult = isValidInput(username, password, retypePassword);
    if (!validationResult.success) {
      return { status: 'error', error: validationResult.message };
    }

    const isUsernameExists =
      (await db.user.checkUsernameExists(username)) == 1 ? true : false;
    if (isUsernameExists) {
      return { status: 'error', error: 'Username already exists' };
    }

    if (password !== retypePassword) {
      return { status: 'error', error: 'Passwords do not match' };
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const [rows] = await db.user.callSpCreateUser(id, username, hashedPassword);
    const data = helper.emptyOrRows(rows);

    return { status: 'success', data: data };
  } catch (error) {
    return { status: 'error', error: error.message };
  }
}

// validate data
function isValidInput(username, password, retypePassword) {
  // Check if all fields are filled

  if (!username || !password || !retypePassword) {
    return { success: false, message: 'All fields are required' };
  }

  // Check username length
  if (username?.length < 3) {
    return {
      success: false,
      message: 'Username must be at least 3 characters long',
    };
  }

  // Check password length
  if (password?.length < 8) {
    return {
      success: false,
      message: 'Password must be at least 8 characters long',
    };
  }

  // Check if password contains at least one uppercase letter, one lowercase letter, and one special character
  const uppercaseRegex = /[A-Z]/;
  const lowercaseRegex = /[a-z]/;
  const specialCharRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;

  if (
    !uppercaseRegex.test(password) ||
    !lowercaseRegex.test(password) ||
    !specialCharRegex.test(password)
  ) {
    return {
      success: false,
      message:
        'Password must contain at least one uppercase letter, one lowercase letter, and one special character',
    };
  }

  // Check if password and retypePassword match
  if (password !== retypePassword) {
    return { success: false, message: 'Passwords do not match' };
  }

  return { success: true }; // All checks passed
}
*/
async function getAllUsers(page = 1) {
  const offSet = helper.getOffset(page, config.listPerPage);
  const [rows] = await db.user.callSpGetAllUsers(offSet, config.listPerPage);
  const data = helper.emptyOrRows(rows);
  return data;
};

const getUser = async (id) => {
  const [rows] = await db.user.callSpGetUser(id);
  const data = helper.emptyOrRows(rows);
  return data;
};

module.exports = {
  getAllUsers,
  getUser,
};
