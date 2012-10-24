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

  for observer of config.observers
    observers.push require(observer)

  for name, location of config.bots
    bots.push Bot.create location, {name: name}

  j = 0
  run = ->
    game = new Game(players, betting)
    game.run()
    game.on 'roundComplete', ->
      #console.log game.status()
    game.on 'complete', (status) ->
      console.log "Round #{j}"
      j++
      numPlayer = (players.filter (p) -> p.chips > 0).length
      if j == maxRounds or numPlayer < 2
        console.log players.map (p) -> "Name: #{p.name} - $#{p.chips}"
        process.exit()
      else
        console.log players.map (p) -> "Name: #{p.name} - $#{p.chips}"
        players = players.concat(players.shift())
        run()

  # Ugly
  async.until (-> bots.filter((bot) -> !bot.loaded).length == 0),
    ((cb) -> setTimeout(cb,200)),
    ->
      for bot, i in bots
        players.push new Player(bot, chips, i)
      run()
