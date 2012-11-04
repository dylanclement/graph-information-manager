is_category = require '../models/conclusions/is_category'

exports.is_a_category = (req, res, graphDB, dataDB) ->
  conclusion = new is_category graphDB, dataDB
  res.json
    name: 'is_category'