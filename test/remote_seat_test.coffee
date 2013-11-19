assert = require 'assert'
Bot = require '../src/seats/remote'

fakeGame = require("./fixtures/game_data.json")
url = "http://randbot.herokuapp.com/randBot"

describe "Basic remote run bot", ->
  @timeout 10000

  it "should set itself up", (done) ->
    Bot.create url, (err, bot) ->
      assert.equal bot.name, 'The Amazing RandBot'
      done()

  it "should accept game data and return bets", (done) ->
    Bot.create url, (err, bot) ->
      bot.update fakeGame, (err, bet) ->
        assert.ok bet >= 0
        done()
