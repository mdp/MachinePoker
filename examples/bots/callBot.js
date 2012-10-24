exports.play = function(me, game) {
  if(me.minToCall){
    return me.minToCall;
  } else { return 0 }
};
exports.name = "CallBot";
