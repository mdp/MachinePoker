var MachinePoker = require('../lib/index');
var narrator = MachinePoker.observers.narrator;
var fileLogger = MachinePoker.observers.fileLogger('./examples/results.json');

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

