var MachinePoker = require('../lib/index')
    , LocalSeat = MachinePoker.seats.JsLocal
    , RemoteSeat = MachinePoker.seats.Remote
    , CallBot = require('./bots/callBot')
    , RandBot = require('./bots/randBot')
    , FoldBot = require('./bots/foldBot')
    , narrator = MachinePoker.observers.narrator
    , fileLogger = MachinePoker.observers.fileLogger('./examples/results.json');

var table = MachinePoker.create({
  maxRounds: 100
});

// Source be found at: https://github.com/mdp/RandBot
var remotePlayerUrl = "http://randbot.herokuapp.com/randBot";

var remotePlayer = RemoteSeat.create(remotePlayerUrl);
remotePlayer.on('ready', function () {
  var players = [
    remotePlayer
    , LocalSeat.create(CallBot)
    , LocalSeat.create(FoldBot)
    , LocalSeat.create(RandBot)
    , LocalSeat.create(RandBot)
  ];
  table.addPlayers(players);
  table.on('tournamentClosed', function () { process.exit() } );
  table.start();
});

// Add some observers
table.addObserver(narrator);
table.addObserver(fileLogger);

