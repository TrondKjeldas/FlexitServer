require('coffee-script/register')
var FlexitInterface = require('../flexit')

var express = require('express');
var router = express.Router();

var flexit = FlexitInterface.get()

/* GET users listing. */
router.get('/speed', function(req, res) {
  res.send('respond with a resource');
});

module.exports = router;
