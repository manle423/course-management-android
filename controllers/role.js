const roleService = require('../services/role');

/**
 * @route POST roles/
 * @desc Add a role
 * @access Private
 */
const createRole = async (req, res, next) => {
  const { name } = req.body;

  try {
    const rs = await roleService.createRole(name);
    res.json(rs);
  } catch (error) {
    console.error('Error creating role:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

/**
 * @route GET roles/
 * @desc Show all roles
 * @access Public
 */
const getAllRoles = async (req, res, next) => {
  try {
    const page = req.query.page;
    const roles = await roleService.getAllRoles(page);
    res.json(roles);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  createRole,
  getAllRoles,
};
