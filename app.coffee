express = require 'express'
  , neo4j = require 'neo4j'
  , routes = require './routes'
  , user = require './routes/user'
  , relationship = require './routes/relationship'
  , http = require 'http'
  , path = require 'path'

app = express()
db = new neo4j.GraphDatabase 'http://localhost:7474'

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