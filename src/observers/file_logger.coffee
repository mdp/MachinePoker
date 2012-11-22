{inspect} = require('util')
fs = require('fs')


module.exports = (filename) ->
  buffers = []
  ready = false

  stream = fs.createWriteStream("#{process.cwd()}/#{filename}");
  console.log stream
  stream.once 'open', ->
    console.log "READY"
    ready = true

  write = (data) ->
    if ready
      for buffer in buffers
        stream.write(buffer)
      stream.write data
    else
      buffers.push data

  complete: (game) ->
    if game.state == 'complete'
      write "#{inspect(game, false, 6)}\n\n"
