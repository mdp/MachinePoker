fs = require('fs')

module.exports = (filename) ->
  buffers = []
  ready = false
  finished = false
  finishedCallback = false
  gameCount = 0

  stream = fs.createWriteStream("#{process.cwd()}/#{filename}");
  stream.once 'open', ->
    ready = true
    write("[\n")

  stream.once 'close', ->
    observerFinished()

  write = (data, end) ->
    if ready
      for buffer in buffers
        stream.write(buffer)
      if end
        stream.end(data)
      else
        stream.write data
    else
      buffers.push data

  observerFinished = ->
    finished = true
    finishedCallback?()

  complete: (game) ->
    if gameCount > 0
      write ",\n#{JSON.stringify(game)}"
    else
      write "#{JSON.stringify(game)}"
    gameCount++

  tournamentComplete: (players) ->
    write "]", true

  onObserverComplete: (callback) ->
    if finished
      setImmediate(callback)
    else
      finishedCallback = callback

