var MachinePoker = require('../lib/index');
var LocalBot = require('../lib/local_bot');
var RemoteBot = require('../lib/remote_bot');
var async = require('async');
var narrator = MachinePoker.observers.narrator;
var fileLogger = MachinePoker.observers.fileLogger('./examples/results.json');

var table = MachinePoker.create({
  maxRounds: 10
});

// Source be found at: https://github.com/mdp/RandBot
var remotePlayerUrl = "http://randbot.herokuapp.com/randBot";

async.map([
  './examples/bots/callBot'
  , './examples/bots/callBot'
  , './examples/bots/randBot'
  , './examples/bots/randBot'
  , './examples/bots/foldBot'
], LocalBot.create, function (err, results) {
  RemoteBot.create(remotePlayerUrl, function (err, bot) {
    results.push(bot)
    if (!err) {
      table.addPlayers(results);
      table.start();
    } else { throw err }
  });
});

// Add some observers
table.addObserver(narrator);
table.addObserver(fileLogger);

