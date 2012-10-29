![Machine
Poker](https://s3.amazonaws.com/img.mdp.im/MachinePokerLogo.png)
# Machine Poker

## 2013 Competition

The rules of Machine Poker are simple:

- You're bot must be written in Javascript and less than 16k in size
- The game will be "No Limit Texas Holdem"
- Everyone starts with $1000 in chips
- The small and big blinds will be 10 and 20 respectively
- Games will be played until only one player is left, or 10,000 hands
- After 10,000 hands the player with the most chips wins(Tie's will be broken by sudden death)
- Programs are stateless, with the exception of a 4k brain

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

### Guide to building your bot

Coming soon


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
- Build a logger to keep track of the games played
- Build a client to display the games played and actions taken

