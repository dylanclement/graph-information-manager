orientdb = require 'orientdb'

dbConfig =
  user_name: "admin"
  user_password: "admin"

serverConfig =
    host: "localhost"
    port: 2424
    user_name: "admin"
    user_password: "admin"

server = new orientdb.Server serverConfig
db = new orientdb.GraphDb "temp", server, dbConfig

body =
  obj : "Object"
  rel : "Relationship"
  sub : "Subject"

obj =
  name: body.obj
  id : 0
  type: "Object"

sub =
  name: body.sub
  id : 1
  type: "Subject"

class Relationship
  constructor: (@db) ->

  save: (object, relationship, subject, callback) ->
    # Create the object, subject and relationship objects
    obj =
      name: object
    rel =
      name: relationship
      createdAt: Date
    sub = 
      name: subject

    # save the object, subject and relationship to the db
    # TODO! check if the obj and sub exist before trying to save
    db.createVertex obj, (err, objNode) ->
      if err
        console.log "Error occured:#{err}"
        return
      db.createVertex sub, (err, subNode) ->
        if err
          console.log "Error occured:#{err}"
          return
        db.createEdge objNode, subNode, (err, edge) ->
          if err
            console.log "Error occured:#{err}"
            return
          console.log "Saved #{objNode}->#{relationship}->#{sub}"
          callback err

db.open (err, result) ->
  if err
    console.log "Error occured:#{err}"
    return

  rel = new Relationship db
  rel.save "dog", "eat", "dog biscuits", (err) ->    
    if err
      console.log "Error occured:#{err}"
      return