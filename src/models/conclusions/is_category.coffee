Conclusion = require '../conclusion'
module.exports = class IsCategory extends Conclusion
  constructor: (@graphdb, @datadb, @logger) ->
    sql = "SELECT Gremlin('current.groupCount{it.name}.cap.next().sort{a,b -> b.value <=> a.value}[0..1]') FROM OGraphEdge";
    super 'is_a', sql, @graphdb, @datadb, @logger

  run: (callback) ->
    @logger.log "Running consclusion", { name: @name}
    @graphdb.command @sql, callback
