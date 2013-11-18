fs = require 'fs'
request = require 'request'
util = require 'util'
crypto = require 'crypto'
{Bot} = require('./bot')
tmpDir = __dirname + "/../../tmp"

exports.Bot = class RemoteBot extends Bot

  constructor: (@url, @opts) ->
    @opts ||= {}
    @debug = true if @opts.debug
    @timeout = @opts.timeout || 1000
    # Allow for spinning up cold Heroku bots
    @setupTimeout = @opts.setupTimeout || 10000

  setup: (url, callback) ->
    request.get {url: url, json: true, timeout: @setupTimeout}, (e, r, response) =>
      if e || r.statusCode != 200
        console.log(e, r.statusCode)
        callback(e || "Returned #{r.statusCode}")
        return false
      @info = response.info
      @name = @info.name || "Unnamed - #{url}"
      callback(null)

  update: (game, callback) ->
    result = 0
    request.post {url: @url, body: game, json: true, timeout: @timeout}, (e, r, response) ->
      if e || r.statusCode != 200
        console.log(e, response)
        callback(e, 0) # Check Fold on error
      else
        callback(null, response.bet)

exports.create = (url, opts, callback) ->
  if arguments.length == 2
    callback = arguments[arguments.length - 1]
    opts = {}
  bot = new RemoteBot(url, opts)
  console.log "Creating bot for - #{url}" if (bot.debug)
  bot.setup url, (err) ->
    callback(err, bot)
  bot

