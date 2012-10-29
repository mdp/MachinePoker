fs = require 'fs'
request = require 'request'
util = require 'util'
{Pitboss} = require 'pitboss'

class Bot

  constructor: (@opts) ->
    @opts ||= {}
    @name = @opts['name'] || "Unnamed"
    @opts['brainSize'] ||= 4096
    @brain = {}
    @loaded = false

  setup: (code) ->
    code = """
       // Debug setup
       var debug = [];
       var console = {};
       console.log = function(txt){debug.push(txt)};

       // CommonJS compat
       var module = {};
       var exports = module.exports = {};
       #{code};
       var result = {}
       var bet = exports.play(game);
       result = {
         bet: bet,
         brain: game.me.brain,
         debug: debug
       }
       result // Return results to Pitboss
    """
    @player = new Pitboss(code)
    @loaded = true

  update: (game, callback) ->
    game.me.brain = @brain
    @player.run {game: game}, (err, result) =>
      if err
        callback(err)
      else
        for debug in result['debug']
          console.log util.inspect(result['debug'], false, 6)
        @saveBrain(result['brain'])
        callback?(null, result['bet'])

  saveBrain: (brainObj) ->
    length = JSON.stringify(brainObj || {})
    if length > @opts['brainSize']
      # Brain too big! Poof, new brain!
      @brain = {}
    else
      @brain = brainObj

exports.create = (id, opts, callback) ->
  bot = new Bot(opts)
  console.log "Creating bot for - #{id}"
  retrieveBot id, (err, code) ->
    bot.setup(code)
  bot

retrieveBot = (id, callback) ->
  if id.match(/^http/)
    request id, (err, response, body) ->
      if err
        callback?(err)
      else
        callback?(null, body.toString())
  else
    fs.readFile id, (err, data) ->
      if err
        callback?(err)
      else
        callback?(null, data.toString())


