exports.name = function() {
    return "FoldBot";
};

exports.play = function(game) {
  if(game.state !== "complete") {
    return 0;
  }
};
