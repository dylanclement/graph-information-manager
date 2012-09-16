# Add node
exports.new = (req, res, relationship) ->
  body = req.body
  console.log body.Obj
  relationship.relation body.Obj, body.Rel, 1.0, body.Sub, (err, node) ->
    if err
      res.send "Error occured: #{err}"
      console.log "Error occured: #{err}"
      return
    res.send 'saved object #{node}'