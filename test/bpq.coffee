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

  describe "Logic", ->
    it "should not exceed size of the queue", ->
      queue = new BPQ 3
      queue.insert({a:3}, 7)
      queue.insert({a:1}, 5)
      queue.insert({a:2}, 6)
      queue.insert({a:3}, 2)
      queue.insert({a:1}, 1)
      queue.insert({a:2}, 9)
      expect(queue.getObjects()).to.have.length 3

    it "should only maintain the lowest priorities in the queue, in order", ->
      queue = new BPQ 3
      queue.insert({a:3}, 7)
      queue.insert({a:1}, 5)
      queue.insert({a:2}, 6)
      queue.insert({a:3}, 2)
      queue.insert({a:1}, 1)
      queue.insert({a:2}, 9)
      expect(queue.getObjects()).to.deep.equal [{a:1}, {a:3}, {a:1}]

    it "should also work if we cannot fill the queue", ->
      queue = new BPQ 10
      queue.insert({a:3}, 7)
      queue.insert({a:1}, 5)
      queue.insert({a:2}, 6)
      expect(queue.getObjects()).to.deep.equal [{a:1}, {a:2}, {a:3}]
