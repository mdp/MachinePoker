assert = require 'assert'
Bot = require '../src/seats/js_local'

fakeGame = require("./fixtures/game_data.json")

describe "Basic locally run bot", ->

  it "should set itself up", (done) ->
    Bot.create './examples/bots/callBot', (err, bot) ->
      assert.equal bot.name, 'CallBot'
      done()

  it "should accept game data and return bets", (done) ->
    Bot.create './examples/bots/callBot', (err, bot) ->
      bot.update fakeGame, (err, bet) ->
        assert.ok bet == 0
        done()
