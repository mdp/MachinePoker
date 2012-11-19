{inspect} = require('util')
exports.complete = (status) ->
  if status.state == 'complete'
    process.stdout.write "\n#{inspect(status, false, 6)}\n"
