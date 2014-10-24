util = require 'util'
SerialPort = require('serialport').SerialPort
serial = new SerialPort '/dev/ttyACM0', { baudrate: 57600 }

socket = null

express = require('express')
express_ws = require('express-ws')
app = express_ws(express())

app.get '/', (req, res) ->
  res.sendFile "#{__dirname}/index.html"

app.ws '/', (ws, req) ->
  ws.on 'message', (msg) ->
    if msg is 'ready' and socket is null
      socket = ws
  ws.on 'error', (err) ->
    socket = null
  ws.on 'close', ->
    socket = null

app.listen process.env.PORT or 5000, ->
  console.log "[#{process.pid}] listening on :#{process.env.PORT or 5000}"
  serial.on 'open', ->
    serial.on 'data', (data) ->
      socket?.send "#{data}"
      console.log "#{data}"
