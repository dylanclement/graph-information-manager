graphDb = require '../services/graphdb'
chai = require('chai') #actually call the the function
expect = chai.expect
winston = require 'winston'

# Set up logging
logger = new winston.Logger transports: [new (winston.transports.Console)()]

describe "GraphDb", ->
  describe "connect to graphDb", ->
    it "should succeed to graphDB", (done) ->
      dbConfig = 
        user_name : "admin"
        user_password: "admin"
      dbServerConfig = 
        host: "localhost"
        port: 2424
        user_name: "admin"
        user_password: "admin"
      
      db = new graphDb dbConfig, dbServerConfig, "temp", logger
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.equal(undefined)
        done()

    it "should not connect to invalid graphDB", (done) ->
      dbConfig = 
        user_name : "bob"
        user_password: "loblaw"
      dbServerConfig = 
        host: "localhost"
        port: 2456
        user_name: "bob"
        user_password: "loblaw"
      
      db = new graphDb dbConfig, dbServerConfig, "temp", logger
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.not.equal(undefined)
        done()

  describe "graphDb functionality", ->  
    # declare unit test variables, connect to the in-memory temp database
    dbConfig = 
      user_name : "admin"
      user_password: "admin"
    dbServerConfig = 
      host: "localhost"
      port: 2424
      user_name: "admin"
      user_password: "admin"
    db = new graphDb dbConfig, dbServerConfig, "temp", logger

    beforeEach ->
      # clear the db before each test
      db.clear (err, results) ->
        expect(err).to.equal(null)

    it "should be able to save a object", (done) ->   
      # make sure the db exists and open a connection
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.equal(undefined)
        # create an object named 'test'
        db.createObject name :'test', (err, subNode) ->
          expect(err).to.equal(null)
          expect(subNode).not.to.equal(null)
          expect(subNode.name).to.equal('test')
          done()

    it "should be able to save a relation", (done) ->   
      # make sure the db exists and open a connection
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.equal(undefined)
        # create 2 objects
        db.createObject name :'test1', (err, test1) ->
          expect(err).to.equal(null)
          db.createObject name :'test2', (err, test2) ->
            expect(err).to.equal(null)
            # create a relationship between the 2 objects
            db.createRelation test1, test2, name: 'rel', (err, edge) ->
              expect(err).to.equal(null)
              expect(edge).not.to.equal(null)
              expect(edge.name).to.equal('rel')
              done()          