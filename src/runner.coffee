fs = require('fs')
play = require('./play')

if(process.argv.length > 2)
  configFile = process.argv[process.argv.length - 1]
else
  configFile = 'config.json'

config = JSON.parse(fs.readFileSync(configFile))

play.start(config)
