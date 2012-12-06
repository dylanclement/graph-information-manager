neo4j = require 'neo4j'

module.exports = class GraphDB
  constructor: (_dbConfig, _serverConfig, _dbname, @logger) ->
    @db = new neo4j.GraphDatabase 'http://localhost:7474'
  
  open: (callback) -> 
    return callback null

  close: ->
    #@db.close()  

  command: (cmd, callback) ->
    @db.execute  cmd, callback

  clear: (callback) ->
    @db.command "DELETE from OGraphEdge", (err, results) =>
      @db.command "DELETE from OGraphVertex", (err, results) ->
        if callback then callback err, results

  getObject: (name, callback) ->
    @command "select from OGraphVertex where name = '#{name}'", (err, results) ->
      callback err, results

  createObject: (obj, callback) ->
    @getObject obj.name, (err, results) =>
      if results and results[0]
        @logger.info "Vertex exists", name: results[0].name
        @updateAccessCount results[0]
        return callback null, results[0]
      node = @db.createNode obj
      node.save callback
      @logger.info "Created vertex", name: obj.name
      return node

  getRelation: (name, from, to, callback) ->
    @command "select from OGraphEdge where name = '#{name}' and out = '#{out_id}' and in = '#{in_id}'", (err, results) ->
      callback err, results

  createRelation: (obj, sub, relationship, callback) ->
    @getRelation relationship.name, obj["@rid"], sub["@rid"], (err, results) =>
      if results and results[0]
        @logger.info "Edge exists: #{obj.name}->#{results[0].name}->#{sub.name}"
        @updateAccessCount results[0]
        return callback null, results[0]
      @db.createEdge obj, sub, relationship, callback
      @logger.info "Created edge", name: relationship.name

  getOutRelations: (node, callback) ->
    @db.getOutEdges node, callback

  getInRelations: (node, callback) ->
    @db.getInEdges node, callback

  countRecords: (callback) ->
    @db.countRecords callback

  getAllObjects: (callback) ->
    @command 'select from OGraphVertex', callback
    
  getAllObjects_Gremlin: (callback) ->
    @command 'SELECT Gremlin(\'current\') from OGraphVertex', callback

  updateAccessCount: (obj, callback) ->
    unless obj and obj["@rid"]?
      return callback new Error("Must pass a valid object to updateAccessCount")
    @command "UPDATE #{obj["@rid"]} INCREMENT access_count = 1", (err, results) ->
      return callback err, results if callback
