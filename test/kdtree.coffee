require 'mocha'
expect = require('chai').expect
KDtree = require '../coffee/kdtree'

describe "KD-tree", ->
  describe "1D construction", ->
    tree = new KDtree [{a:10}, {a: 2}, {a: 5}]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree

    it "should construct a tree with the median as its root", ->
      expect(tree.getRoot().val.a).to.equal 5

    it "should have the lower node as left child", ->
      expect(tree.getRoot().left.val.a).to.equal 2

    it "should have the higher node as right child", ->
      expect(tree.getRoot().right.val.a).to.equal 10

  describe "2D construction", ->
    # Example from http://en.wikipedia.org/wiki/K-d_tree
    tree = new KDtree [{x:2, y:3}, {x:5,y:4}, {x:9,y:6}, {x:4,y:7}, {x:8,y:1}, {x:7,y:2}], ["x", "y"]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree
      #console.log require('util').inspect tree.getRoot(), colors: true, depth: 5

    it "should have the root at x = 7", ->
      expect(tree.getRoot().val).to.deep.equal {x:7, y:2}

    it "should have the correct first left child", ->
      expect(tree.getRoot().left.val).to.deep.equal {x:5, y:4}

    it "should have the correct right left child", ->
      expect(tree.getRoot().right.val).to.deep.equal {x:9, y:6}

    it "should build the complete correct tree", ->
      expect(tree.getRoot().left.left.val).to.deep.equal {x:2, y:3}
      expect(tree.getRoot().left.right.val).to.deep.equal {x:4, y:7}
      expect(tree.getRoot().right.left.val).to.deep.equal {x:8, y:1}
      expect(tree.getRoot().right.right).to.equal null
