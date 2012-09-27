  redis = require 'redis'
  , dbConfig = require "../config/datadbConfig"

  module.exports = class DataDB
    constructor: ->
      @client = redis.createClient dbConfig.port
    
    open: (callback) -> 
      @client.on "error", (err) -> console.log "Redis error: #{err}"
      callback()
      
    close: ->
      @client.quit()