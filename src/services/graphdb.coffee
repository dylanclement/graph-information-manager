orientdb = require 'orientdb'
, dbConfig = require "../../config/graphdbConfig"
, serverConfig = require "../../config/graphdbServerConfig"

module.exports = class GraphDB
  constructor: ->
    @server = new orientdb.Server serverConfig
    @db = new orientdb.GraphDb "temp", @server, dbConfig
  
  open: (callback) -> 
    @db.open (err) ->
      if err
        console.log "Error opening database: #{err}"
      return callback err

  close: ->
    @db.close()

  command: (cmd, callback) ->
    @db.command cmd, callback

  getObject: (name, callback) ->
    @command "select from OGraphVertex where name = '#{name}'", (err, results) ->
      if err
        console.log "Err:#{err}"
        return callback err
      callback err, results

  createObject: (obj, callback) ->
    @getObject obj.name, (err, results) =>
      if results and results[0]
        console.log "Vertex exists: #{results[0]}"
        return callback null, results[0]
      @db.createVertex obj, callback
      console.log "Created vertex: #{obj.name}"

  getRelation: (name, out_id, in_id, callback) ->
    @command "select from OGraphEdge where name = '#{name}' and out = '#{out_id}' and in = '#{in_id}'", (err, results) ->
      if err
        console.log "Err:#{err}"
        return callback err
      callback err, results

  createRelation: (obj, sub, relationship, callback) ->
    @getRelation relationship.name, obj["@rid"], sub["@rid"], (err, results) =>
      if results and results[0]
        console.log "Edge exists: #{results[0]}"
        return callback null, results[0]
      @db.createEdge obj, sub, relationship, callback
      console.log "Created edge: #{relationship.name}"

  getOutRelations: (node, callback) ->
    @db.getOutEdges node, callback

  getInRelations: (node, callback) ->
    @db.getInEdges node, callback

  countRecords: (callback) ->
    @db.countRecords callback

  getAllObjects: (callback) ->
    @command 'select from OGraphVertex', callback
    
  getAllObjects_Gremlin: (callback) ->
    @command 'select from GREMLIN("V.out")', callback

  getEntity: (name, callback) ->
    @getVertex name, callback
