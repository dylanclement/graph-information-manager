module.exports = class Conclusion
  constructor: (@name, @sql, @graphdb, @datadb, @logger) ->
    @logger.info "Created conclusion #{name}"

  run: (callback) ->
    @logger.info "Running conclusion", name : @name
    @graphdb.command @sql, callback
    