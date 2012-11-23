assert = require 'assert'
{Bot} = require '../src/bot'

fakeGame = {self:{}}

describe "Basic bot", ->
  beforeEach ->
    @code =
      '''
      exports.name = "Johnny Moss";
      exports.play = function(game) {
        return 20;
      };

      '''
    name = "Checkbot"
    @bot = new Bot({name:name})

  it "should be able to name themselves", (done) ->
    @bot.setup(@code)
    @bot.once 'loaded', ->
      assert.equal @name, 'Johnny Moss'
      done()

  it "should be able to bet", (done) ->
    @bot.setup(@code)
    @bot.once 'loaded', ->
      @update fakeGame, (err, bet) ->
        assert.equal bet, 20
        done()
