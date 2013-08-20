require 'mocha'
expect = require('chai').expect
KDtree = require '../coffee/kdtree'

describe "KD-tree", ->
  describe "construction", ->
    tree = new KDtree [{a:10}, {a: 2}, {a: 5}]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree

    it "should construct a tree with the median as its root", ->
      expect(tree.getRoot().val.a).to.equal 5

    it "should have the lower node as left child", ->
      expect(tree.getRoot().left.val.a).to.equal 2

    it "should have the higher node as right child", ->
      expect(tree.getRoot().right.val.a).to.equal 10
