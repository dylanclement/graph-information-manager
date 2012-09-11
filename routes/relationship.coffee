# Add node
exports.new = (req, res, db) ->
  body = req.body
  ###info = db.createNode  { "Object" : body.Object }
  info.save (error) ->
    if error
      console.log 'Error ' + error + ' occured.'
      return
    console.log 'Node ' + body.Object + ' saved.'  ###
  obj = 
    name: body.Obj
    id : 0
    type: "Object"

  subj = 
    name: body.Sub
    id : 1
    type: "Subject"

  db.createVertex obj, (err, rootNode) ->
    assert !err, err
    db.createVertex subj, (err, childNode) ->
      assert !err, err
      db.createEdge rootNode, childNode, (err, edge) ->
        assert !err, err
        console.log "Relationship between #{body.Object} to #{body.Subject} saved."
  res.send  'saved object'