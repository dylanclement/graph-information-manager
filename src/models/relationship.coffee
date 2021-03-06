module.exports = class Relationship
  constructor: (@graphdb, @datadb, @inputStream, @logger) ->

  # save the object, subject and relationship to the db
  relation: (obj, rel, strength, sub, callback) ->
    # TODO! check if the obj and sub exist before trying to save
    @graphdb.createObject name : obj, (err, objNode) =>
      if err
        @logger.error "Unable to create object", { err: err, name: obj }
        return callback err
      @graphdb.createObject name : sub, (err, subNode) =>
        if err
          @logger.error "Unable to create subject", { err: err, name: sub }
          return callback err
        @graphdb.createRelation objNode, subNode, { name : rel, strength: strength, created_at : Date.now(), access_count : 0 }, (err, edge) =>
          if err
            @logger.error "Unable to create relation", { err: err, obj: obj, rel: rel, sub: sub }
            return callback err
          @logger.info "Saved #{objNode.name}(#{objNode["@rid"]})->#{edge.name}(#{edge["@rid"]})->#{subNode.name}(#{subNode["@rid"]}). Access count = #{edge.access_count}"
          @inputStream.write "#{objNode.name},#{edge.name},#{subNode.name},#{Date.now()}\n"
          callback err, objNode

  # eg. a dog is a animal
  is_a: (obj, sub, strength = 1.0, callback) ->
    @relation obj, "is_a", strength, sub, callback

  # eg. a dog has a nose
  has_a: (obj, sub, strength = 1.0, callback) ->
    @relation obj, "has_a", strength, sub, callback

  all: (callback) ->
    @graphdb.getAllObjects callback

  allGremlin: (callback) -> 
    @graphdb.getAllObjects_Gremlin callback
    