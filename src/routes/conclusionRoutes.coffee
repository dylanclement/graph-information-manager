is_category = require '../models/conclusions/is_category'

exports.is_a_category = (req, res, graphDB, dataDB) ->
  conclusion = new is_category graphDB, dataDB
  conclusion.run (err, results) ->
    if err
      return res.send "Error occured: #{err}"    
    res.json
      results: results