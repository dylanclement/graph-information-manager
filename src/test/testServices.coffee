graphDb = require '../services/graphdb'
chai = require('chai') #actually call the the function
expect = chai.expect

describe "Services", ->
  describe "connect", ->
    it "should succeed to graphDB", (done) ->
      dbConfig = 
        user_name : "admin"
        user_password: "admin"
      dbServerConfig = 
        host: "localhost"
        port: 2424
        user_name: "admin"
        user_password: "admin"
      
      db = new graphDb dbConfig, dbServerConfig, "temp"
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
      
      db = new graphDb dbConfig, dbServerConfig, "temp"
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.not.equal(undefined)
        done()

  describe "graphDb", ->
    # declare unit test variables
    dbConfig = 
      user_name : "admin"
      user_password: "admin"
    dbServerConfig = 
      host: "localhost"
      port: 2424
      user_name: "admin"
      user_password: "admin"
    db = new graphDb dbConfig, dbServerConfig, "temp"

    it "should be able to save a relation", (done) ->   
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.equal(undefined)
        db.createObject name :"test", (err, subNode) ->
          expect(err).to.equal(null)
          done()