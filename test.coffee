GraphDb = require "./services/graphdb"
Relationship = require "./models/relationship"
db = new GraphDb
rel = new Relationship db

db.open ->
  rel.is_a "dog", "animal", 1.0, (node, err) ->    
    if err
      console.log "Error occured:#{err}"
      return
    db.getOutEdges node, (err, outEdges) ->
      console.log "out Edges = #{outEdges}."
    db.countRecords (err, count) ->
      console.log "Number of records = #{count}."
    db.close()