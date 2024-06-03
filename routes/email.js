const express = require("express");
const router = express.Router();
const { sendMail } = require('../controllers/email.js');

router.post("/data", sendMail);

module.exports = router;
