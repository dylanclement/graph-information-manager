is_category = require '../models/conclusions/is_category'

exports.is_a_category = (req, res, graphDB, dataDB, @logger) ->
  conclusion = new is_category graphDB, dataDB, @logger
  conclusion.run (err, results) ->
    if err
      @logger.err "Error occured", { err: err}
      return res.send "Error occured: #{err}"
    res.json
      results: results