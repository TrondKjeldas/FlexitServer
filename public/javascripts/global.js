// DOM Ready =============================================================
$(document).ready(function() {

  getSystemState();

  $('#btnHighSpeed').on('click', highSpeed);
  $('#btnNormalSpeed').on('click', normalSpeed);
  $('#btnLowSpeed').on('click', lowSpeed);

  $('#btnHeatingOn').on('click', heatingOn);
  $('#btnHeatingOff').on('click', heatingOff);
});

// Functions =============================================================

// Fill table with data
function getSystemState() {

  // jQuery AJAX call for JSON
  $.getJSON('/fan/speed', function(data) {
    $('#fanSpeed').text(data==1?"low":data==2?"normal":"high");
  });

  $.getJSON('/heating', function(data) {
    $('#heating').text(data?"on":"off");
  });

  $.getJSON('/filterclogged', function(data) {
    $('#filterClogged').text(data?"clogged":"ok");
  });

  $.getJSON('/overheated', function(data) {
    $('#overHeated').text(data?"yes":"no");
  });

  $.getJSON('/operational', function(data) {
    $('#operational').text(data?"yes":"no");
  });
};


function setSpeed(speed) {

  event.preventDefault();

  // Use AJAX to post the object to our adduser service
  $.ajax({
    type: 'POST',
    data: {'speed' : speed},
    url: '/fan/speed',
    dataType: 'JSON'
  }).done(function(response) {

    // Check for successful (blank) response
    if (response.msg === '') {
      getSystemState();
    } else {
      // If something goes wrong, alert the error message that our service returned
      alert('Error: ' + response.msg);
    }
  });
};

function highSpeed(event) {
  setSpeed(3);
};
function normalSpeed(event) {
  setSpeed(2);
};
function lowSpeed(event) {
  setSpeed(1);
};

function setHeating(state) {

  event.preventDefault();

  // Use AJAX to post the object to our adduser service
  $.ajax({
    type: 'POST',
    data: {'state' : state},
    url: '/heating',
    dataType: 'JSON'
  }).done(function(response) {

    // Check for successful (blank) response
    if (response.msg === '') {
      getSystemState();
    } else {
      // If something goes wrong, alert the error message that our service returned
      alert('Error: ' + response.msg);
    }
  });
};

function heatingOn(event) {
  setHeating(true);
};
function heatingOff(event) {
  setHeating(false);
};
