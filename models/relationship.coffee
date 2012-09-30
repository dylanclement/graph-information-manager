module.exports = class Relationship
  constructor: (@graphdb, @datadb) ->

  # save the object, subject and relationship to the db
  relation: (obj, rel, strength, sub, callback) ->
    # TODO! check if the obj and sub exist before trying to save
    @graphdb.createVertex name : obj, (err, objNode) =>
      if err
        console.log "Error occured:#{err}"
        return callback err
      @graphdb.createVertex name : sub, (err, subNode) =>
        if err
          console.log "Error occured: #{err}"
          return callback err
        @graphdb.createEdge objNode, subNode, { name : rel, strength: strength, createdAt : Date }, (err, edge) =>
          if err
            console.log "Error occured:#{err}"
            return callback err
          @datadb.getData "#{obj}:#{rel}:#{sub}", (err, data) =>
            console.log "Saved #{objNode.name}(#{objNode["@rid"]})->#{edge.name}(#{edge["@rid"]})->#{subNode.name}(#{subNode["@rid"]}). Access count = #{data.access_count}"
            callback err, objNode

  # eg. a dog is a animal
  is_a: (obj, sub, strength = 1.0, callback) ->
    @relation obj, "is_a", strength, sub, callback

  # eg. a dog has a nose
  has_a: (obj, sub, strength = 1.0, callback) ->
    @relation obj, "has_a", strength, sub, callback

  all: (callback) ->
    @graphdb.getAllVertexes callback

  allG: (callback) -> 
    @graphdb.getAllGremlinVertexes callback    