  redis = require 'redis'

  module.exports = class DataDB
    constructor: (config, @logger) ->
      @client = redis.createClient config?.port ? dbConfig.port
    
    open: (callback) -> 
      @client.on "error", (err) -> logger.error "Redis error", { err: err }
      callback()
      
    close: ->
      @client.quit()

    getData: (obj, rel, sub, cond, callback) ->
      key = "#{obj}:#{rel}:#{sub}:#{cond}"
      @client.hgetall key, (err, data) =>
        if err
          @logger.error "Error: Fetching meta-data.", { err: err, key: key }
          return callback err
        unless data
          @logger.log "Creating new data ", { key: key, data: data }
          data =
            created: new Date()
            try_create_count: 0
            access_count: 0
        else
          data = JSON.parse data
        data.access_count += 1
        data.try_create_count += 1
        @client.hmset key, JSON.stringify(data)
        return callback err, data
        