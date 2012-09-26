express = require 'express'
  , GraphDb = require "./services/graphdb"
  , Relationship = require "./models/relationship"  
  , routes = require './routes'
  , test = require './routes/test'
  , relationship = require './routes/relationship'
  , http = require 'http'
  , path = require 'path'
  , redis = require 'redis'

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
  app.use require('less-middleware')(src: "#{__dirname}/public" )
  app.use express.static(path.join __dirname, 'public')

app.configure 'development', ->
  app.use express.errorHandler()

app.listen app.get('port'), ->
  console.log "node-mem-graph server listening on port #{app.get 'port'}."
  db.open ->
    console.log "connected to graph db."
    client = redis.createClient 3630
    console.log "connected to redis db."
    client.on "error", (err) ->
        console.log "Error " + err

    app.get '/', routes.index
    app.get '/test', test.list
    app.get '/relationship/list', (req, res) -> 
      relationship.list(req, res, rel)
    app.post '/relationship/new', (req, res) -> 
      relationship.new(req, res, rel)