var fs = require('fs');

var play = require('./lib/play');

var argv = require('optimist').argv;

var configFile = 'config.json';
if (argv._.length > 0) {
  configFile = argv._[0]
}

var config = JSON.parse(fs.readFileSync(configFile));

if (argv.maxRounds) {
  config.maxRounds = parseInt(argv.maxRounds, 10);
}

play.start(config);

