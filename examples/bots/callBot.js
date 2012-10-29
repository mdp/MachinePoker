exports.play = function(game) {
  if(game.state !== "complete") {
    if(game.betting.minToCall){
      return game.betting.minToCall - game.me.wagered;
    } else { return 0 }
  }
};
