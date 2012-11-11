express = require 'express'
  , dbConfig = require "../config/dbConfig"
  , GraphDb = require "./services/graphdb"
  , DataDb = require "./services/datadb"
  , Relationship = require "./models/relationship"  
  , routes = require './routes'
  , relationshipRoute = require './routes/relationshipRoutes'
  , conclusionRoute = require './routes/conclusionRoutes'
  , http = require 'http'
  , path = require 'path'
  , redis = require 'redis'
  , fs = require 'fs'
  , winston = require 'winston'

# create a date  yyyy-mm-dd method
Date.prototype.yyyymmdd = () ->
   yyyy = this.getFullYear().toString()
   mm = (this.getMonth()+1).toString() # getMonth() is zero-based
   dd  = this.getDate().toString()
   return "#{yyyy}-#{(if mm.length > 1 then mm else '0' + mm[0])}-#{(if dd.length > 1 then dd else '0' + dd[0])}" # padding

# Set up logging
logger = new winston.Logger
  transports: [
    new (winston.transports.Console)(),
    new (winston.transports.File) filename: "application-#{new Date().yyyymmdd()}.log"
  ]
logger.on 'error', (err) -> console.log "Unhandled error occured, #{err}"
inputStream = fs.createWriteStream "input.csv", 'flags': 'a'

# Connect to DB's
graphDB = new GraphDb dbConfig.graphDb, dbConfig.graphDbServer, dbConfig.graphDbName, logger
dataDB = new DataDb dbConfig.dataDb, logger

# Set up business logic
rel = new Relationship graphDB, dataDB, inputStream, logger

# Create express app
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
  logger.info "server listening on http://localhost:#{app.get 'port'}."

  # Connect to db's
  graphDB.open (err) ->
    if err
      logger.err "Unable to connect to graphDb", { err: err }
      return
    logger.info "connected to graph db."
    dataDB.open (err) ->
      if err
        logger.err "Unable to connect to dataDb", { err: err }
        return
      logger.info "connected to redis db."

      # Set up routes
      app.get '/', routes.index
      app.get '/relationship/list', (req, res) -> relationshipRoute.list(req, res, rel)
      app.post '/relationship/new', (req, res) -> relationshipRoute.new(req, res, rel, logger)
      app.get '/relationship/all', (req, res) -> relationshipRoute.all(req, res, rel)
      app.get '/conclusion/is_a_category', (req, res) -> conclusionRoute.is_a_category(req, res, graphDB, dataDB, logger)