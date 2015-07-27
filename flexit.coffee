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

      # Outputs
      @H2 = off
      @H3 = off
      @EV = off

      # Inputs
      @FI = off
      @BT = off
      @DR = off

      @serialPort = null

      serialport.list( (err, ports) =>
        console.log "Available ports:"
        for port in ports
          console.log('   ' + port.comName)
        if ports.length < 1
          return
        portToUse = ports[0].comName
        console.log "Using port: " + portToUse
        @serialPort = new serialport.SerialPort(portToUse,
            {
              baudrate: 9600,
              parser: serialport.parsers.readline("\n")
            }
        )

        @serialPort.on("open",
          () =>
            console.log ('Port ' + portToUse + ' opened')

            @serialPort.on('data', (data) =>
              if data.indexOf("D") == 0 or data.indexOf("R") == 0
                console.log('data received: ' + data)

              if(data.indexOf("RO 8") > -1)
                if data[5] == "0"
                  @H2 = on
                else
                  @H2 = off

              if(data.indexOf("RO 9") > -1)
                if data[5] == "0"
                  @H3 = off
                else
                  @H3 = on

              if(data.indexOf("RO 10") > -1)
                if data[6] == "0"
                  @EV = off
                else
                  @EV = on

              if(data.indexOf("DI 2") > -1)
                if data[5] == "0"
                  @FI = on
                else
                  @FI = off

              if(data.indexOf("DI 3") > -1)
                if data[5] == "0"
                  @BT = on
                else
                  @BT = off

              if(data.indexOf("DI 4") > -1)
                if data[5] == "0"
                  @DR = on
                else
                  @DR = off
            )

            setTimeout(
              () =>
                @serialPort.write("SUBSCRIBE CHANGES ON\r\n",
                  (err, results) =>
                    if err
                      console.log('err ' + err)
                      console.log('results ' + results)
                )

              3000
            )
        )
      )

    close: ->
      @serialPort?.close()
      console.log "port closed."

    writeToSerialPort: (string) ->
      console.log ("Writing: " + string)
      @serialPort.write(string, (err, results) =>
        if err
          console.log('err ' + err)
          console.log('results ' + results)
      )

    writeVal: (string, val) ->
      c = if val then "1" else "0"
      @writeToSerialPort(string + " " + c + "\r\n")

    updateOutputs: ->
      @writeVal("SET RO 8", @H2)
      @writeVal("SET RO 9", @H3)
      @writeVal("SET RO 10", @EV)

    fanspeed: ->
      if @H2 and not @H3
        return 1
      else if @H3 and @H2
        return 3
      else if not @H2 and not @H3
        return 2

    setfanspeed: (speed) ->
      if speed == 2
        @H2 = off
        @H3 = off
      else if speed == 3
        @H3 = on
        @H2 = on
      else
        @H2 = on
        @H3 = off

      @updateOutputs()

    heating: -> return @EV

    setheating: (state) ->
      @EV = state
      @updateOutputs()

    filterclogged: -> return @FI

    overheated: -> return @BT

    operational: -> return @DR
