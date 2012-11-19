exports.name = function() {
    return "CallBot";
};

exports.play = function(game) {
  if(game.state !== "complete") {
    return game.betting.call
  }
};
