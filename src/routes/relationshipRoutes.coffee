# Add node
exports.new = (req, res, relationship, @logger) ->
  body = req.body
  relationship.relation body.Obj, body.Rel, 1.0, body.Sub, (err, node) ->
    if err
      @logger.log "Error occured", { err }
      res.send "Error occured: #{err}"
      return
    # TODO! make this a bootstrap notification
    res.send 'saved object #{node}'

exports.list = (req, res, relationship) ->
  relationship.all (err, results) ->
    res.render 'relations', { title: "Relationships", list: results }
    