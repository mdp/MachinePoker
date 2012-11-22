![Machine
Poker](https://s3.amazonaws.com/img.mdp.im/MachinePokerLogo.png)
# Machine Poker

## Getting started

### Requirements

- NodeJS >= 0.8.x
- A basic understanding of javascript

### Installation

#### Via NPM

    npm install MachinePoker

#### Local

    git clone git://github.com/mdp/MachinePoker.git
    cd MachinePoker
    npm install

### Build your bot

Check [this guide on the wiki](MachinePoker/wiki) to start building your own bot

### Cofiguring a new game

New matches are built using the Machine Poker API

    var MachinePoker = require('MachinePoker');
    var narrator = MachinePokers.observers.narrator;
    var narrator = MachinePokers.observers.fileLogger('results.json');

    var table = MachinePoker.create({
      maxRounds: 10
    });

    table.addPlayer('./examples/bots/callBot.js');
    table.addPlayer('./examples/bots/callBot.js');
    table.addPlayer('./examples/bots/randBot.js');

    // Add some observers
    table.addObserver(narrator);
    table.addObserver(fileLogger);

    table.on('ready', function() {
      console.log('ready');
      return table.start();
    });


### Updating the repo

The sample bots will evolve over the coming weeks in order to give you
some better opponents. You can just update the repo to keep up to date.

    git pull origin master

### Todo

- Get this working under windows (mainly just install instructions)
- Build a file logger to keep track of the games played

