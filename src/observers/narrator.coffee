{Hand} = require "hoyle"
{Card} = require 'hoyle'

`redColor   = '\033[31m';
blueColor  = '\033[34m';
resetColor = '\033[0m';`

narratorLogAction = (logStr) ->
  console.log redColor + logStr + resetColor

narratorLogState = (logStr) ->
  console.log blueColor + logStr + resetColor

narratorLog = (logStr) ->
  console.log logStr

playerInfoString = (player, communityCards) ->
  playerCards = ""
  if player.cards?
    for card in player.cards
      playerCards += card + " "
    if communityCards?
      playerCards = (new Card c for c in player.cards)
      c = []
      c = c.concat(communityCards)
      c = c.concat(playerCards)
      handName = Hand.make(c).name
      if handName? and handName != 'High card' then playerCards += " (#{handName})"
  return "#{player.name} ($#{player.chips}) #{playerCards}"

actionString = (action, bet) ->
  switch action
    when 'bet' then return 'bet $' + bet
    when 'raise' then return 'raised by $' + bet
    when 'fold' then return 'folded'
    when 'allIn' then return 'went ALL IN with $' + bet
    when 'call' then return 'called $' + bet
    when 'check' then return 'checked'

exports.roundStart = (status) ->
  narratorLog " "
  narratorLogState "==== Round ##{status.hand} starting ===="
  narratorLogState status.players.length + " players:"
  for player in status.players
    narratorLogState "  " + playerInfoString(player, null)

exports.betAction = (player, action, bet, err) ->
  if err
    narratorLogAction "  #{player.name} failed to bet: #{err}"
  else
    narratorLogAction "  #{player.name} #{actionString(action, bet)}"

exports.stateChange = (status) ->
  stateName = status.state
  narratorLog " "
  narratorLogState "-- #{stateName}"
  if stateName == 'pre-flop'
    for player in status.players
      narratorLogState "  #{playerInfoString(player, null)}"

    for player in status.players
      if player.blind > 0 then narratorLogAction "  #{player.name}  paid a blind of $#{player.blind}"

  else
    cards = ""
    for card in status.community
      cards = cards + card + " "
    narratorLogState " Cards are: #{cards}"

    pot = 0
    for player in status.players
      if player.wagered? then pot += player.wagered
    narratorLogState " Pot is: #{pot}"

    communityCards = (new Card c for c in status.community)
    for player in status.players
      if (player.state == 'active' || player.state == 'allIn') then narratorLogState "  #{playerInfoString(player, communityCards)}"
    narratorLogAction " Actions: "

exports.complete = (status) ->
  narratorLog " "
  narratorLogState "Round ##{status.hand} complete."
  if status.winners.length > 1
    narratorLogState "Winners are:"
    for winner in status.winners
      narratorLogState "#{status.players[winner.position].name} with #{status.players[winner.position].handName}. Amount won: $#{ + winner.amount}"

  else
    winningPlayer = status.players[status.winners[0].position]
    handName = ""
    if winningPlayer.handName? then handName = "with #{winningPlayer.handName}"
    narratorLogState "Winner was #{winningPlayer.name} #{handName} Amount won: $#{status.winners[0].amount}"

  narratorLogState "Positions: "
  for player in status.players
    cardString = ""
    if player.cards?
      for card in player.cards
        cardString += card + " "
    handName = ""
    if player.handName? then handName = "(#{player.handName})"
    narratorLogState "#{player.name} ($#{player.chips}) had #{cardString} #{handName}"
  narratorLogState "================================="
