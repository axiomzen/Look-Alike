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

    it "should allow me to fetch max and min priority of the queue", ->
      queue = new BPQ 5
      queue.insert({a:3}, 7)
      queue.insert({a:1}, 5)
      queue.insert({a:2}, 6)
      expect(queue.getMaxPriority()).to.equal 7
      expect(queue.getMinPriority()).to.equal 5
