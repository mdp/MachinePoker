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
    var narrator = MachinePokers.observers.narrator;
    var fileLogger = MachinePokers.observers.fileLogger('results.json');

    var table = MachinePoker.create({
      maxRounds: 100
    });

    async.map([
      './examples/bots/callBot'
      , './examples/bots/callBot'
      , './examples/bots/randBot'
      , './examples/bots/randBot'
      , './examples/bots/foldBot'
    ], Bot.create, function (err, results) {
      if (!err) {
        table.addPlayers(results);
        table.start();
      } else { throw err }
    });

    // Add some observers
    table.addObserver(narrator);
    table.addObserver(fileLogger);

### Updating the repo

The sample bots will evolve over the coming weeks in order to give you
some better opponents. You can just update the repo to keep up to date.

    git pull origin master

### Todo

- Build remote Bot handlers so that we can sandbox players in Docker container

