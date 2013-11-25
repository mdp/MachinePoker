fs = require 'fs'
request = require 'request'
util = require 'util'
crypto = require 'crypto'
{Seat} = require('../seat')
tmpDir = __dirname + "/../../tmp"

# This should only be used to run bots that you trust

exports.Seat = class JsLocal extends Seat

  constructor: (@opts) ->
    @opts ||= {}
    @debug = true if @opts.debug
    @loaded = false

  setup: (module) ->
    @player = module
    @playerInfo = module.info || {}
    @name = @playerInfo.name || "Unnamed"
    @setupFinished()

  setupFinished: (err) =>
    @loaded = true
    @emit 'ready'

  update: (game, callback) ->
    if (@debug)
      startTime = Date.now()
    result = @player.update(game)
    if (@debug)
      console.log("Execution of \"" + @name + "\" took " + (Date.now() - startTime) + " ms.")
    setImmediate -> callback(null, result)

exports.create = (id, opts, callback) ->
  if arguments.length == 2
    callback = arguments[arguments.length - 1]
    opts = {}
  bot = new JsLocal(opts)
  if typeof id == 'function'
    # Do this syncronously for ease of coding
    bot.setup(new id())
  else
    # Retreive the bot from a remote source
    # Will need to watch for callback completion
    console.log "Creating bot for - #{id}" if (bot.debug)
    retrieveBot id, (err, mod) ->
      if err
        throw err
      bot.setup(new mod())
      callback?(null, bot)
  bot

retrieveBot = (id, callback) ->
  mod = null
  err = null
  if id.match(/^https?/)
    shasum = crypto.createHash('sha1')
    name = null
    request id, (err, response, body) ->
      fileName = shasum.update(body).digest('hex')
      filePath = "#{tmpDir}/#{fileName}"
      if err
        callback?(err)
      else
        fs.writeFile filePath, body, (err) ->
          try
            mod = require(filePath)
          catch e
            err = e
          callback(err, mod)
  else
    try
      mod = require("#{process.cwd()}/#{id}")
    catch e
      err = e
    callback(err, mod)

