express = require 'express'
  , GraphDb = require "./services/graphdb"
  , Relationship = require "./models/relationship"  
  , routes = require './routes'
  , user = require './routes/user'
  , relationship = require './routes/relationship'
  , http = require 'http'
  , path = require 'path'

db = new GraphDb
rel = new Relationship db

app = express()

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

app.listen app.get('port'), ->
  console.log "node-mem-graph server listening on port #{app.get 'port'} ."
  db.open ->
    app.get '/', routes.index
    app.get '/users', user.list
    app.post '/relationship/new', (req, res) -> 
      relationship.new(req, res, rel)