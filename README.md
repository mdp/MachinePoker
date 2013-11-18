[![Build Status](https://secure.travis-ci.org/mdp/MachinePoker.png)](http://travis-ci.org/mdp/MachinePoker)

![Machine
Poker](https://s3.amazonaws.com/img.mdp.im/MachinePokerLogo.png)
# Machine Poker

Machine Poker is a libray which allows you go build poker bots
and have them compete against each other in tournaments.

Currently this supports bots written in Javascript running locally,
or bots that play remotely via HTTP and conform to the MachinePoker API

## Getting started

### Requirements

- NodeJS >= 0.10.x
- A basic understanding of javascript

#### Dependencies

- [Hoyle](https://github.com/mdp/hoyle) - Poker hand library
- [Binions](https://github.com/mdp/binions) - Poker table library
- Request
- Async
- Optimist

### Installation

#### Via NPM

    npm install machine-poker

#### Local

    git clone git://github.com/mdp/MachinePoker.git
    cd MachinePoker
    npm install

### Build your bot

Check [this guide on the wiki](MachinePoker/wiki) to start building your own bot

### Cofiguring a new game

New matches are built using the Machine Poker API

    var MachinePoker = require('machine-poker');
        , LocalSeat = MachinePoker.seats.JsLocal
        , RemoteSeat = MachinePoker.seats.Remote
        , CallBot = require('./examples/bots/callBot')
        , RandBot = require('./examples/bots/randBot')
        , FoldBot = require('./examples/bots/foldBot')
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

### Updating the repo

The sample bots will evolve over the coming weeks in order to give you
some better opponents. You can just update the repo to keep up to date.

    git pull origin master

### Todo

- Fix wiki

