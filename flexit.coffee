serialport = require("serialport");

module.exports =
class FlexitInterface

  instance = null

  # Get singleton instance
  @get: ->
    instance ?= new FlexitInterfaceImplementation()

  # Implementation of singleton class
  class FlexitInterfaceImplementation

    constructor: () ->
      # body...
      @H2 = off
      @H3 = off
      @EV = off
      @FI = off
      @BT = off

      @serialPort = new serialport.SerialPort("/dev/ttyACM0",
      {
        baudrate: 9600,
        parser: serialport.parsers.readline("\n")
      })

      @serialPort.on("open",
        () =>
          console.log('open')

          @serialPort.on('data', (data) =>
            if data.indexOf("D") > -1
              console.log('data received: ' + data)

            if(data.indexOf("DO 8") > -1)
              if data[5] == "0"
                @H2 = off
              else
                @H2 = on

            if(data.indexOf("DO 9") > -1)
              if data[5] == "0"
                @H3 = off
              else
                @H3 = on

            if(data.indexOf("DO 10") > -1)
              if data[5] == "0"
                @EV = off
              else
                @EV = on

            if(data.indexOf("DI 2") > -1)
              if data[5] == "0"
                @FI = off
              else
                @FI = on

            if(data.indexOf("DI 3") > -1)
              if data[5] == "0"
                @BT = off
              else
                @BT = on
          )

          setTimeout(
            () =>
              @serialPort.write("SUBSCRIBE CHANGES ON\r",
                (err, results) =>
                  console.log('err ' + err)
                  console.log('results ' + results)
              )

            3000
          )
      )

    updateOutputs: ->
      console.log "TODO: update outputs"

    fanspeed: ->
      if @H2
        return 2
      else if @H3
        return 3
      else
        return 1

    setfanspeed: (speed) ->
      if speed == 2
        @H2 = on
        @H3 = off
      else if speed == 3
        @H3 = on
        @H2 = off
      else
        @H2 = off
        @H3 = off

      @updateOutputs()

    heating: -> return @EV

    setheating: (state) ->
      @EV = state
      @updateOutputs()

    filterclogged: -> return @FI

    overheated: -> return @BT
