const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { v4: uuidv4 } = require("uuid");
const db = require("./databases");
const helper = require("../helper");
require("dotenv").config();

const login = async (username, password) => {
  try {
    const users = await db.user.callSpGetUserByUsername(username);
    if (!users) {
      throw new Error("User not found");
    }
    const user = users[0];
    // console.log('user:', user);
    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
      throw new Error("Incorrect password");
    }

    const token = jwt.sign(
      { userId: user.user_id, username: user.username, role_id: user.role_id },
      process.env.JWT_SECRET_KEY,
      {
        expiresIn: 86400,
      }
    );
    // const token = jwt.sign({ userId: user.user_id, username: user.username }, "1");
    return token;
  } catch (error) {
    throw error;
  }
};

const register = async (username, password, retypePassword) => {
  const id = uuidv4();
  try {
    const validationResult = isValidInput(username, password, retypePassword);
    if (!validationResult.success) {
      return { status: "error", error: validationResult.message };
    }

    const isUsernameExists = await db.user.checkUsernameExists(username);
    // const check = isUsernameExists[0][0].username_available;
    // console.log(isUsernameExists[0][0].username_available);
    if (isUsernameExists == 1) {
      return { status: "error", error: "Username already exists" };
    }

    if (password !== retypePassword) {
      return { status: "error", error: "Passwords do not match" };
    }

    if (password !== retypePassword) {
      return { status: "error", error: "Passwords do not match" };
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const rows = await db.user.callSpCreateUser(id, username, hashedPassword);
    // console.log(rows);
    const data = helper.emptyOrRows(rows);
    // return rows;
    return { status: "success", data: data };
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

const logout = async (token) => {
  try {
    const check = await db.blacklist.checkTokenInBlacklist(token);
    // console.log(check);
    if (check) {
      return { status: "success", "msg": "You are logged out" };
    }
    await db.blacklist.callSpAddToBlacklist(token);
    return { status: "success", "msg": "You are logged out" };
  } catch (error) {
    return { status: "error", error: error.message };
  }
};

// validate data
const isValidInput = (username, password, retypePassword) => {
  // Check if all fields are filled

  if (!username || !password || !retypePassword) {
    return { success: false, message: "All fields are required" };
  }

  // Check username length
  if (username?.length < 3) {
    return {
      success: false,
      message: "Username must be at least 3 characters long",
    };
  }

  // Check password length
  if (password?.length < 8) {
    return {
      success: false,
      message: "Password must be at least 8 characters long",
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
        "Password must contain at least one uppercase letter, one lowercase letter, and one special character",
    };
  }

  // Check if password and retypePassword match
  if (password !== retypePassword) {
    return { success: false, message: "Passwords do not match" };
  }

  return { success: true }; // All checks passed
};

module.exports = {
  login,
  register,
  logout,
};
