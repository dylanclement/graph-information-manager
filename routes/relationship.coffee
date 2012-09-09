# Add node
exports.new = (req, res, db) ->
  body = req.body
  info = db.createNode  { "Object" : body.Object }
  info.save (error) ->
    if error
      console.log 'Error ' + error + ' occured.'
      return
    console.log 'Node ' + body.Object + ' saved.'  
  res.send  'saved object'