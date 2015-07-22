# FlexitServer

Small "REST-like" web-server interface to a Flexit air handling unit

## Hardware:

The Flexit unit is interfaced via an Arduino UNO with an IO shield,
and running the FW from https://github.com/TrondKjeldas/ArduinoIO.git.

## Docker:

Build cmd: sudo docker build -t flexi-server . 

Run cmd: sudo docker run --device /dev/ttyACM0 --rm --net=host flexi-server
