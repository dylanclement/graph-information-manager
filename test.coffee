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

db.createVertex obj, (err, rootNode) ->
  console.log "Test 1"
  assert !err, err
  db.createVertex sub, (err, childNode) ->
    assert !err, err
    db.createEdge rootNode, childNode, (err, edge) ->
      assert !err, err
      console.log "Relationship between #{body.obj} to #{body.sub} saved."