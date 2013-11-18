var MachinePoker = require('../lib/index');
var LocalSeat = MachinePoker.seats.JsLocal
var RemoteSeat = MachinePoker.seats.Remote
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
], LocalSeat.create, function (err, results) {
  RemoteSeat.create(remotePlayerUrl, function (err, bot) {
    results.push(bot)
    if (!err) {
      table.addPlayers(results);
      table.on('tournamentClosed', function(){process.exit()});
      table.start();
    } else { throw err }
  });
});

// Add some observers
table.addObserver(narrator);
table.addObserver(fileLogger);

