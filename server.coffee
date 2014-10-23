SerialPort = require('serialport').SerialPort
serial = new SerialPort '/dev/ttyACM0', { baudrate: 57600 }
serial.on 'open', ->
  console.log 'comm port online'
  serial.on 'data', (data) ->
    console.log "data! #{data}"

# koa, from the makers of express
koa = require 'koa'
time = require 'koa-response-time'
serve = require 'koa-static'
logger = require 'koa-logger'
websocket = require 'koa-ws'

websocket_options = {
  serveClientFile: true,
  clientFilePath: '/ws.js',
  heartbeat: true,
  heartbeatInterval: 5000
}

# choose our middleware here
app = koa()
app.use time()
app.use logger()
app.use websocket(app, websocket_options)
app.use serve(__dirname + '/public')

app.listen process.env.PORT or 5000, ->
  port = @_connectionKey.split(':')[2]
  console.log "[#{process.pid}] listening on :#{port}"
