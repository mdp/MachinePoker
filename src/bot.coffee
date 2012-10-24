fs = require 'fs'
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
       var bet = exports.play(me, game);
       result = {
         bet: bet,
         brain: me.brain,
         debug: debug
       }
       result // Return results to Pitboss
    """
    @player = new Pitboss(code)
    @loaded = true

  act: (me, game, callback) ->
    me.brain = @brain
    @player.run {me: me, game: game}, (err, result) =>
      if err
        callback(err)
      else
        for debug in result['debug']
          console.log result['debug']
        @saveBrain(result['brain'])
        callback?(null, result['bet'])

  saveBrain: (brainObj) ->
    length = JSON.stringify(brainObj || {})
    if length > @opts['brainSize']
      # Brain too big! Poof, new brain!
      @brain = {}
    else
      @brain = brainObj

exports.create = (filename, opts, callback) ->
  bot = new Bot(opts)
  console.log "bot created - #{filename}"
  fs.readFile filename, (err, data) ->
    bot.setup(data.toString())
    callback?()
  bot

