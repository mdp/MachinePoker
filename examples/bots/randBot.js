exports.play = function(game) {
  if(game.state !== "complete") {
    if(game.betting.minToCall){
      return game.betting.minToCall - game.me.wagered;
    } else { return 0 }
    var heads = Math.random() > 0.5;
    if(heads) {
        return game.betting.minToRaise - game.me.wagered;
    } else {return game.betting.minToCall}
  }
};
