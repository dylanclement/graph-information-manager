orientdb = require 'orientdb'
, dbConfig = require "../config/graphdbConfig"
, serverConfig = require "../config/graphdbServerConfig"

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
    unless obj.name
      console.log 'Can\'t create an object without a name.'
      return
    @getObject obj.name, (err, results) =>
      if results and results[0]
        dbObj = results[0]
        console.log "Vertex exists: ", dbObj
        dbObj.access_count = if dbObj.access_count? then dbObj.access_count + 1 else 1
        dbObj.updated_at = Date.now()
        @db.createVertex @prepObject(dbObj), callback  
        return callback null, dbObj
      @db.createVertex @prepObject(obj), callback
      console.log "Created vertex: #{obj.name}"
      return callback null, obj

  getRelation: (name, objId, subId, callback) ->
    unless objId and subId
      errorMsg = "Please provide valid 'in' (#{objId}) and 'out' (#{subId}) entities to getRelation"
      console.log errorMsg
      return callback new Error errorMsg
    @command "select from OGraphEdge where name = '#{name}' and in = #{objId} and out = #{subId}", (err, results) ->
      if err
        console.log "Err:#{err}"
        return callback err
      callback err, results

  createRelation: (obj, sub, relationship, callback) ->
    console.log obj, sub
    @getRelation relationship.name, obj?[@rid], sub?[@rid], (err, results) =>
      if results and results[0]
        dbObj = results[0]
        console.log "Edge exists: ", dbObj
        dbObj.access_count = if dbObj.access_count? then dbObj.access_count + 1 else 1
        dbObj.updated_at = Date.now()
        return callback null, dbObj
      @db.createEdge obj, sub, relationship, callback
      console.log "Created edge: #{obj?.name}->#{relationship.name}->#{sub?.name}"
      return callback null, relationship

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

  prepObject: (obj) ->
    obj.access_count ?=  1
    obj.created_by ?= "system"
    obj.created_at ?= Date.now()
    obj