module.exports = class Conclusion
  constructor: (@name, @sql, @graphdb, @datadb) ->
    console.log "Created conclusion #{name}"

  run: ->
    @command @sql, (err, results) ->
      if err
        console.log "Conclusion Error:#{err}"
        return callback err
      console.log "Running consclusion #{@name}."
