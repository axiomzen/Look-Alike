require 'mocha'
should = require('chai').should()
expect = require('chai').expect
BPQ = require '../coffee/bpq'

describe "Bounded Priority Queue", ->
  it "should return an instance of BPQ", ->
    queue = new BPQ(5)
    queue.should.be.instanceof BPQ
