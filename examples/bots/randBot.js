exports.play = function(me, game) {
  var heads = Math.random() > 0.5;
  if(heads) {
      return me.minToRaise;
  } else {return me.minToCall}
};
exports.name = "RandBot";
