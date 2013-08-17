require 'mocha'
expect = require('chai').expect
BPQ = require '../coffee/bpq'

describe "Bounded Priority Queue", ->
  describe "Basics", ->
    it "should return an instance of BPQ", ->
      queue = new BPQ 5
      expect(queue).to.be.instanceof BPQ

    it "should allow me to insert an element", ->
      queue = new BPQ 5
      queue.insert({a:1}, 5)
      expect(queue.getObjects()).to.deep.equal [{a:1}]
