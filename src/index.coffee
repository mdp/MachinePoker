{EventEmitter} = require 'events'
binions = require 'binions'
{Player} = binions
{Game} = binions
Bot = require './bot'

exports.betting = binions.betting
exports.observers =
  fileLogger: require './observers/file_logger'
  logger: require './observers/logger'
  narrator: require './observers/narrator'

exports.create = (betting) ->
  new MachinePoker(betting)

class MachinePoker extends EventEmitter
  constructor: (@opts) ->
    @opts ?= {}
    @chips = @opts.chips || 1000
    @maxRounds = @opts.maxRounds || 100
    @betting = @opts.betting || binions.betting.noLimit(10,20)
    @botsToLoad = 0
    @players = []
    @observers = []

  addPlayer: (playerId, botOpts) ->
    botOpts ?= {}
    botOpts.name ||= 'Unnamed'
    @botsToLoad++
    process.nextTick =>
      bot = Bot.create(playerId, botOpts)
      console.log "Loading #{playerId}}"
      bot.once 'loaded', (err) =>
        if err
          throw "Error loading bot #{playerId} - #{err}"
        player = new Player(bot, @chips, bot.name)
        player.on 'betAction', (action, amount, err) =>
          @obsNotifier 'betAction', player, action, amount, err
        @players.push player
        @botsToLoad--
        if @botsToLoad == 0
          @emit 'ready'

  addObserver: (obs) ->
    @observers.push(obs)

  obsNotifier: (type) ->
    args = Array.prototype.slice.call(arguments, 1)
    for observer in @observers
      if observer[type]
        observer[type].apply(this, args)

  start: ->
    currentRound = 1
    @players.sort ->
      Math.random() > 0.5 # Mix up the players before a tournament
    run = =>
      game = new Game(@players, @betting, currentRound)
      game.on 'roundStart', =>
        @obsNotifier 'roundStart', game.status(Game.STATUS.PRIVILEGED)
      game.on 'stateChange', (state) =>
        @obsNotifier 'stateChange', game.status(Game.STATUS.PRIVILEGED)
      game.once 'complete', (status) =>
        @obsNotifier 'complete', game.status(Game.STATUS.PRIVILEGED)
        currentRound++
        numPlayer = (@players.filter (p) -> p.chips > 0).length
        if currentRound > @maxRounds or numPlayer < 2
          @obsNotifier 'tournamentComplete', @players
          @exit()
        else
          @players = @players.concat(@players.shift())
          run()
      game.run()
    run()

  exit: ->
    waitingOn = 0
    for obs in @observers
      if obs['onObserverComplete']
        waitingOn++
        obs.onObserverComplete ->
          waitingOn--
          if waitingOn <= 0
            process.exit()
    if waitingOn <= 0
      process.exit()
