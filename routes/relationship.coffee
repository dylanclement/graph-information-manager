# Add node
exports.new = (req, res, relationship) ->
  body = req.body
  relationship.relation body.Obj, body.Rel, 1.0, body.Sub, (err, node) ->
    if err
      res.send "Error occured: #{err}"
      console.log "Error occured: #{err}"
      return
    res.send 'saved object #{node}'

exports.list = (req, res, relationship) ->
  relationship.all (err, results) ->
    res.render 'relations', { title: "Relationships", list: results }