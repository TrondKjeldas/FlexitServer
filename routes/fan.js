require('coffeescript/register')
var FlexitInterface = require('../flexit')

var express = require('express');
var router = express.Router();

var flexit = FlexitInterface.get()

router.get('/speed', function(req, res) {
  res.json(flexit.fanspeed());
});

router.post('/speed', function(req, res) {
  if (req.body.speed == '1') {
    flexit.setfanspeed(1);
    res.send({
      msg: ''
    });
  } else {
    if (req.body.speed == '2') {
      flexit.setfanspeed(2);
      res.send({
        msg: ''
      });
    } else {
      if (req.body.speed == '3') {
        flexit.setfanspeed(3);
        res.send({
          msg: ''
        });
      } else {
        res.send({
          msg: 'invalid speed'
        });
      }
    }
  }
});

module.exports = router;
