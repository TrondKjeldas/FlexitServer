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

      @serialPort = new serialport.SerialPort("/dev/ttyACM0",
      {
        baudrate: 9600,
        parser: serialport.parsers.readline("\n")
      })

      @serialPort.on("open",
          () =>
            console.log('open')

            @serialPort.on('data', (data) =>
              if data.indexOf("DI") > -1
                console.log('data received: ' + data)
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
