Conclusion = require '../conclusion'
module.exports = class IsCategory extends Conclusion
  constructor: (@graphdb, @datadb) ->
    sql = " ";
    super 'is_a', sql, @graphdb, @datadb

  run: (err, callback) ->

    @command @sql, (err, results) ->
      if err
        console.log "Conclusion Error:#{err}"
        return callback err
      console.log "Running consclusion #{@name}."

