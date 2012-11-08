fs = require('fs')
play = require('./play')
argv = require('optimist').argv

configFile = 'config.json'
config = JSON.parse(fs.readFileSync(configFile))

if argv.maxRounds
  config.maxRounds = parseInt(argv.maxRounds, 10)

play.start(config)
