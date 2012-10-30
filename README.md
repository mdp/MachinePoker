![Machine
Poker](https://s3.amazonaws.com/img.mdp.im/MachinePokerLogo.png)
# Machine Poker

## 2013 Competition

The rules of Machine Poker are simple:

- You're bot must be written in Javascript and less than 16k in size
- The game will be "No Limit Texas Holdem"
- Everyone starts with $1000 in chips
- The small and big blinds will be 5 and 10 respectively
- Games will be played until only one player is left, or 1,000 hands
- After 1,000 hands the player with the most chips wins(Tie's will be broken by sudden death)

## Getting started

### Requirements

- NodeJS >= 0.8.x
- A basic understanding of javascript

### Installation

    git clone git://github.com/mdp/MachinePoker.git
    cd MachinePoker
    npm install

### Running a Game

    npm start

### Build your bot

Check [this guide on the wiki](wiki) to start building your own bot

### Cofiguring a new game

Games and players are configured in json - ['config.json'](config.json)

Your first bot exists in ['bot.js'](bot.js). You'll need to teach it to
play poker if you want it to stand a chance of winning.

### Updating the repo

The sample bots will evolve over the coming weeks in order to give you
some better opponents. You can just update the repo to keep up to date.

    git pull origin master

### Todo

- Get this working under windows (mainly just install instructions)
- Build a file logger to keep track of the games played

