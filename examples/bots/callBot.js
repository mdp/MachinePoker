exports.name = "CallBot";

exports.play = function(game) {
  if (game.state !== "complete") {
    return game.betting.call
  }
};
