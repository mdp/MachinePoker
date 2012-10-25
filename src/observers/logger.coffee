round = 0
exports.complete = (status) ->
  console.log "Round ##{round} complete"
  console.log status.players.map (p) -> "#{p.name} - $#{p.chips}"
  round++
