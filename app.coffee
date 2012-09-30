express = require 'express'
  , GraphDb = require "./services/graphdb"
  , DataDb = require "./services/datadb"
  , Relationship = require "./models/relationship"  
  , routes = require './routes'
  , test = require './routes/test'
  , relationship = require './routes/relationship'
  , http = require 'http'
  , path = require 'path'
  , redis = require 'redis'

graphdb = new GraphDb
datadb = new DataDb
rel = new Relationship graphdb, datadb

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
  graphdb.open (err) ->
    if err
      return
    console.log "connected to graph db."
    datadb.open (err) ->
      if err
        return
      console.log "connected to redis db."
      app.get '/', routes.index
      app.get '/test', test.list
      app.get '/relationship/list', (req, res) ->
        relationship.list(req, res, rel)
      app.post '/relationship/new', (req, res) ->
        relationship.new(req, res, rel)
      app.get '/relationship/all', (req, res) ->
        relationship.all(req, res, rel)
