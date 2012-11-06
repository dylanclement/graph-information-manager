express = require 'express'
  , GraphDb = require "./services/graphdb"
  , DataDb = require "./services/datadb"
  , Relationship = require "./models/relationship"  
  , routes = require './routes'
  , test = require './routes/test'
  , relationshipRoute = require './routes/relationshipRoutes'
  , conclusionRoute = require './routes/conclusionRoutes'
  , http = require 'http'
  , path = require 'path'
  , redis = require 'redis'

dbConfig = require "../config/graphdbConfig"
serverConfig = require "../config/graphdbServerConfig"  
graphDB = new GraphDb dbConfig, serverConfig, "temp"

dataDB = new DataDb
rel = new Relationship graphDB, dataDB

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
  app.use require('less-middleware')(src: "#{__dirname}/public" )
  app.use express.static(path.join __dirname, 'public')

app.configure 'development', ->
  app.use express.errorHandler()

app.listen app.get('port'), ->
  console.log "server listening on http://localhost:#{app.get 'port'}."
  graphDB.open (err) ->
    if err
      return
    console.log "connected to graph db."
    dataDB.open (err) ->
      if err
        return
      console.log "connected to redis db."
      app.get '/', routes.index
      app.get '/test', test.list
      app.get '/relationship/list', (req, res) ->
        relationshipRoute.list(req, res, rel)
      app.post '/relationship/new', (req, res) ->
        relationshipRoute.new(req, res, rel)
      app.get '/relationship/all', (req, res) ->
        relationshipRoute.all(req, res, rel)
      app.get '/conclusion/is_a_category', (req, res) ->
        conclusionRoute.is_a_category(req, res, graphDB, dataDB)
