express = require 'express'
  , orientdb = require 'orientdb'
  , routes = require './routes'
  , user = require './routes/user'
  , relationship = require './routes/relationship'
  , http = require 'http'
  , path = require 'path'

app = express()

dbConfig =
  user_name: "admin"
  user_password: "admin"

serverConfig =
    host: "localhost"
    port: 2424
    user_name: "admin"
    user_password: "admin"

GraphDb = orientdb.GraphDb
Server = orientdb.Server

server = new Server serverConfig
db = new GraphDb "temp", server, dbConfig
#db = new orientdb.GraphDatabase 'http://localhost:7474'

app.configure ->
  app.set 'port', process.env.PORT || 3618
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use require('less-middleware', src: __dirname + '/public' )
  app.use express.static(path.join __dirname, 'public')

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', routes.index
app.get '/users', user.list
app.post '/relationship/new', (req, res) -> 
  relationship.new(req, res, db)

app.listen app.get('port'), ->
  console.log "node-mem-graph server listening on port #{app.get 'port'} ."