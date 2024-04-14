var express = require('express');
var router = express.Router();

//->localhost:3000/api/v1
router.use('/admin',require('./admin'))
router.use('/auth',require('./auth'))
router.use('/category',require('./category'))
router.use('/product',require('./product'))
router.use('/user',require('./user'))
module.exports = router;
