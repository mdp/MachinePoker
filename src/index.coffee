{EventEmitter} = require 'events'
async = require 'async'
binions = require 'binions'
{Player} = binions
{Game} = binions

exports.betting = binions.betting
exports.observers =
  fileLogger: require './observers/file_logger'
  logger: require './observers/logger'
  narrator: require './observers/narrator'

exports.create = (betting) ->
  new MachinePoker(betting)

class MachinePoker extends EventEmitter
  constructor:(@opts) ->
    @opts ?= {}
    @chips = @opts.chips || 1000
    @maxRounds = @opts.maxRounds || 100
    @betting = @opts.betting || binions.betting.noLimit(10,20)
    @observers = []
    @players = []
    @currentRound = 1

  addObserver: (obs) ->
    @observers.push(obs)

  addPlayers: (bots) ->
    names = []
    for bot in bots
      name = botNameCollision(names, bot.name)
      @players.push(new Player(bot, @chips, name))
      names.push(name)

  obsNotifier: (type) ->
    args = Array.prototype.slice.call(arguments, 1)
    for observer in @observers
      if observer[type]
        observer[type].apply(this, args)

  run: ->
    game = new Game(@players, @betting, @currentRound)
    game.on 'roundStart', =>
      @obsNotifier 'roundStart', game.status(Game.STATUS.PRIVILEGED)
    game.on 'stateChange', (state) =>
      @obsNotifier 'stateChange', game.status(Game.STATUS.PRIVILEGED)
    game.once 'complete', (status) =>
      @obsNotifier 'complete', game.status(Game.STATUS.PRIVILEGED)
      @currentRound++
      numPlayer = (@players.filter (p) -> p.chips > 0).length
      if @currentRound > @maxRounds or numPlayer < 2
        @obsNotifier 'tournamentComplete', @players
        @cleanUp () ->
          process.exit()
      else
        @players = @players.concat(@players.shift())
        setImmediate => @run()
    game.run()

  start: ->
    @players.sort ->
      Math.random() > 0.5 # Mix up the players before a tournament
    @run()

  cleanUp: (callback) ->
    waitingOn = 0
    for obs in @observers
      if obs['onObserverComplete']
        waitingOn++
        obs.onObserverComplete ->
          waitingOn--
          if waitingOn <= 0
            callback()
    if waitingOn <= 0
      callback()

botNameCollision = (existing, name, idx) ->
  idx ||= 1
  if idx > 1
    name = "#{name} ##{idx}"
  if existing.indexOf(name) >= 0
    return botNameCollision(existing, name, idx + 1)
  return name


