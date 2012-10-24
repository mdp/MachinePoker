var TARGET = "./bot.js";
var SOURCE = "./examples/bots/callBot.js";

var fs = require("fs");

if (!fs.existsSync(TARGET)) {
  var sourceFile = fs.createReadStream(SOURCE);
  var targetFile = fs.createWriteStream(TARGET);
  sourceFile.pipe(targetFile);
}
