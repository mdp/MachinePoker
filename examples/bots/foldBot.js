exports.info = {
  name: "FoldBot"
};

exports.play = function(game) {
  if (game.state !== "complete") {
    return 0;
  }
};
