var fs = require('fs');

var play = require('./lib/play');

var argv = require('optimist').argv;

var configFile = 'config.json';

var config = JSON.parse(fs.readFileSync(configFile));

if (argv.maxRounds) {
  config.maxRounds = parseInt(argv.maxRounds, 10);
}

play.start(config);

