async = require 'async'
fs = require 'fs'
binions = require 'binions'
{Player} = binions
{Game} = binions
Bot = require './bot'

Array::shuffle = -> @sort -> 0.5 - Math.random()

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

  allBots = config.bots
  botsToLoad = 0
  botsToLoad++ for x of allBots
  botNames = []

  for name, location of allBots
    newBot = Bot.create location, {name: name, debug: config.debug, timeout: config.limitations.timeout}, (bot) =>

      # Unique the bot names
      curName = bot.name
      botNum = 2
      while curName in botNames
        curName = bot.name + " #" + botNum
        botNum++
      botNames.push curName
      bot.name = curName
      console.log("Loaded bot " + bot.name)

      player = new Player(bot, chips, bot.name)
      players.push player
      player.on 'betAction', (action, amount, err) ->
        obsNotifier 'betAction', this, action, amount, err
      botsToLoad--
      if (botsToLoad == 0)
        run()
    bots.push newBot

  bots.shuffle()

  obsNotifier = (type) ->
    args = Array.prototype.slice.call(arguments, 1)
    for observer in observers
      if observer[type]
        observer[type].apply(this, args)

  j = 1
  run = ->
    game = new Game(players, betting, j)
    game.on 'roundStart', ->
      obsNotifier 'roundStart', game.status(Game.STATUS.PRIVILEGED)
    game.on 'stateChange', (state) ->
      obsNotifier 'stateChange', game.status(Game.STATUS.PRIVILEGED)
    game.on 'roundComplete', ->
      obsNotifier 'roundComplete', game.status(Game.STATUS.PRIVILEGED)
    game.on 'complete', (status) ->
      obsNotifier 'complete', game.status(Game.STATUS.PRIVILEGED)
      j++
      numPlayer = (players.filter (p) -> p.chips > 0).length
      if j > maxRounds or numPlayer < 2
        process.exit()
      else
        players = players.concat(players.shift())
        run()

    game.run()
