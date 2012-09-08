
/**
 * Module dependencies.
 */

var express = require('express')
  , neo4j = require('neo4j')
  , routes = require('./routes')
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3618);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public' }));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/users', user.list);
app.post('/relationship/new', function(req, res) {
  var body = req.body;
  var info = db.createNode( { "Object" : body.Object } );  
  info.save(function(error) {
    if (error) {
      console.log('Error ' + error + ' occured.');
      return;
    }
    console.log('Node ' + body.Object + ' saved.');
  });
});

http.createServer(app).listen(app.get('port'), function(){
  db = new neo4j.GraphDatabase('http://localhost:7474');
  console.log("node-mem-graph server listening on port " + app.get('port'));
});
