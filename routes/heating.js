require('coffeescript/register')
var FlexitInterface = require('../flexit')

var express = require('express');
var router = express.Router();

var flexit = FlexitInterface.get()

/* GET users listing. */
router.get('', function(req, res) {
  res.json(flexit.heating());
});

router.post('', function(req, res) {
  if (req.body.state === 'true') {
    flexit.setheating(true);
    res.send({
      msg: ''
    });
  } else {
    if (req.body.state === 'false') {
      flexit.setheating(false);
      res.send({
        msg: ''
      });
    } else {
      res.send({
        msg: 'invalid heater state'
      });
    }
  }
});

module.exports = router;
