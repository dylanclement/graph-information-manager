  redis = require 'redis'
  , dbConfig = require "../../config/datadbConfig"

  module.exports = class DataDB
    constructor: ->
      @client = redis.createClient dbConfig.port
    
    open: (callback) -> 
      @client.on "error", (err) -> console.log "Redis error: #{err}"
      callback()
      
    close: ->
      @client.quit()

    getData: (obj, rel, sub, cond, callback) ->
      key = "#{obj}:#{rel}:#{sub}:#{cond}"
      @client.hgetall key, (err, data) =>
        if err
          console.log "Error: Fetching meta-data.", key, err
          return callback err
        unless data
          console.log "Creating new meta-data ", key, data
          data =
            created: new Date()
            try_create_count: 0
            access_count: 0
        else
          data = JSON.parse data
          console.log "data = ", data
        data.access_count += 1
        data.try_create_count += 1
        @client.hmset key, JSON.stringify(data)
        return callback err, data    