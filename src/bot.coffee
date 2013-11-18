{EventEmitter} = require('events')

# Basic bot class
exports.Bot = class Bot extends EventEmitter

  constructor: (@opts) ->
    @opts ||= {}
    @debug = true if @opts.debug

  # Overide me, expects the callback to be called
  # with an integer
  update: (game, callback) ->
    setImmediate -> callback("Error, your should write something here")

exports.create = (id, opts, callback) ->
  if arguments.length == 2
    callback = arguments[arguments.length - 1]
    opts = {}
  bot = new Bot(opts)
  console.log "Creating bot for - #{id}" if (bot.debug)
  callback?(null, bot)

