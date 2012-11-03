graphDb = require '../services/graphdb'
chai = require('chai') #actually call the the function
expect = chai.expect

describe "graphDB", ->
  describe "connecting", ->
    it "should connect to graphDB", (done) ->
      dbConfig = 
        user_name : "admin"
        user_password: "admin"
      dbServerConfig = 
        host: "localhost"
        port: 2424
        user_name: "admin"
        user_password: "admin"
      
      db = new graphDb dbConfig, dbServerConfig
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
      
      db = new graphDb dbConfig, dbServerConfig
      expect(db).to.not.equal(undefined)
      db.open (err) ->
        expect(err).to.not.equal(undefined)
        done()