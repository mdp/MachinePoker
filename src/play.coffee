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
  narrator = null
  chips = config.chips
  betting = binions.betting[config.betting.strategy](config.betting.amounts...)
  maxRounds = config.maxRounds || 100

  for observer in (config.observers || [])
    observers.push require("#{process.cwd()}/#{observer}")
    
  if config.narrator
      narrator = require("#{process.cwd()}/#{config.narrator}")

  for name, location of config.bots
    bots.push Bot.create location, {name: name}

  obsNotifier = (type, msg) ->
    for observer in observers
      if observer[type]
        observer[type](msg)

  j = 1
  run = ->
    game = new Game(players, betting, j)
    game.on 'roundStart', ->
        narrator?.roundStart? game.status(Game.STATUS.PRIVILEGED)
    game.on 'stateChange', (state) ->
        narrator?.stateChange? state, game.status(Game.STATUS.PRIVILEGED)
    game.on 'roundComplete', ->
      obsNotifier 'roundComplete', game.status(Game.STATUS.PRIVILEGED)
    game.on 'complete', (status) ->
      narrator?.roundComplete? game.status(Game.STATUS.PRIVILEGED)
      obsNotifier 'complete', game.status(Game.STATUS.PRIVILEGED)
      j++
      numPlayer = (players.filter (p) -> p.chips > 0).length
      if j > maxRounds or numPlayer < 2
        process.exit()
      else
        players = players.concat(players.shift())
        run()

    game.run()

  # Ugly
  async.until (-> bots.filter((bot) -> !bot.loaded).length == 0),
    ((cb) -> setTimeout(cb,200)),
    ->
      for bot in bots
        player = new Player(bot, chips, bot.name)
        players.push player
        player.on 'betAction', (emittedPlayer, action, amount, err) ->
            narrator?.playerBet?(emittedPlayer, action, amount, err)
      run()
