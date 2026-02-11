require('coffeescript/register')
var FlexitInterface = require('../flexit')

var express = require('express');
var router = express.Router();

var flexit = FlexitInterface.get()

/* GET users listing. */
router.get('', function(req, res) {
    res.json( flexit.filterclogged() );
});

module.exports = router;
