Conclusion = require '../conclusion'
module.exports = class IsCategory extends Conclusion
  constructor: (@graphdb, @datadb) ->
    sql = "SELECT Gremlin('current.groupCount{it.name}.cap.next().sort{a,b -> b.value <=> a.value}[0..1]') FROM OGraphEdge";
    super 'is_a', sql, @graphdb, @datadb

  run: (err, callback) ->

    @command @sql, (err, results) ->
      if err
        console.log "Conclusion Error:#{err}"
        return callback err
      console.log "Running consclusion #{@name}."

