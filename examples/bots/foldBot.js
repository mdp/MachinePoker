exports.play = function(game) {
  if(game.state !== "complete") {
    if(game.betting.minToCall){
      // You gotta know when to fold 'em
      return 0
    }
  }
};
