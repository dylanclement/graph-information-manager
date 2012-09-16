orientdb = require 'orientdb'
dbConfig = require "../config/dbConfig"
serverConfig = require "../config/serverConfig"

module.exports = class GraphDB
  constructor: ->
    @server = new orientdb.Server serverConfig
    @db = new orientdb.GraphDb "temp", @server, dbConfig
  
  open: (callback) -> 
    @db.open callback

  createVertex: (obj, callback) ->
    @db.createVertex obj, callback

  createEdge: (obj, sub, relationship, callback) ->
    @db.createEdge obj, sub, relationship, callback

  getOutEdges: (node, callback) ->
    @db.getOutEdges node, callback

  countRecords: (callback) ->
    @db.countRecords callback

  getAll: (callback) ->
    @db.command 'select from OGraphVertex', callback
    
  close: ->
    @db.close()