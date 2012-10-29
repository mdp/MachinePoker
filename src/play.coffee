async = require 'async'
fs = require 'fs'
binions = require 'binions'
{Player} = binions
{Game} = binions
Bot = require './bot'

exports.start = (config) ->

  observers = []
  players = []
  bots= []
  chips = config.chips
  betting = binions.betting[config.betting.strategy](config.betting.amounts...)
  maxRounds = config.maxRounds || 100

  for observer in (config.observers || [])
    observers.push require("#{process.cwd()}/#{observer}")

  for name, location of config.bots
    bots.push Bot.create location, {name: name}

  obsNotifier = (type, msg) ->
    for observer in observers
      if observer[type]
        observer[type](msg)

  j = 0
  run = ->
    game = new Game(players, betting)
    game.run()
    game.on 'roundComplete', ->
      obsNotifier 'roundComplete', game.status(true)
    game.on 'complete', (status) ->
      obsNotifier 'complete', game.status(true)
      j++
      numPlayer = (players.filter (p) -> p.chips > 0).length
      if j == maxRounds or numPlayer < 2
        process.exit()
      else
        players = players.concat(players.shift())
        run()

  # Ugly
  async.until (-> bots.filter((bot) -> !bot.loaded).length == 0),
    ((cb) -> setTimeout(cb,200)),
    ->
      for bot in bots
        players.push new Player(bot, chips, bot.name)
      run()
