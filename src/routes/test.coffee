# GET users listing.
exports.list = (req, res) ->
  test = 
      name: 'test'
      age: 23
  res.json test