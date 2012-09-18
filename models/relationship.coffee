module.exports = class Relationship
  constructor: (@db) ->

  # save the object, subject and relationship to the db
  relation: (obj, rel, strength, sub, callback) ->
    # TODO! check if the obj and sub exist before trying to save
    @db.createVertex name : obj, (err, objNode) =>
      if err
        console.log "Error occured:#{err}"
        return callback err
      @db.createVertex name : sub, (err, subNode) =>
        if err
          console.log "Error occured: #{err}"
          return callback err
        @db.createEdge objNode, subNode, { name : rel, strength: strength, createdAt : Date }, (err, edge) =>
          if err
            console.log "Error occured:#{err}"
            return callback err
          console.log "Saved #{objNode.name}(#{objNode["@rid"]})->#{edge.name}(#{edge["@rid"]})->#{subNode.name}(#{subNode["@rid"]})"
          callback err, objNode

  # eg. a dog is a animal
  is_a: (obj, sub, strength = 1.0, callback) ->
    @relation obj, "is_a", strength, sub, callback

  # eg. a dog has a nose
  has_a: (obj, sub, strength = 1.0, callback) ->
    @relation obj, "has_a", strength, sub, callback

  all: (callback) ->
    @db.getAllVertexes callback