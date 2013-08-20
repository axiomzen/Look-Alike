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

  describe "3D construction with labels", ->
    tree = new KDtree [{x:1,y:2,z:3, label:'a'}, {x:5,y:2,z:7, label:'b'}, {x:3,y:3,z:4, label:'c'}, {x:5,y:5,z:5, label:'d'}, {x:9,y:0,z:1, label:'e'}, {x:10,y:1,z:3, label:'f'}, {x:5,y:3,z:7, label:'g'}, {x:3,y:9,z:9, label:'h'}, {x:8,y:8,z:8, label:'i'}], ["x", "y", "z"]
    it "should return an instance of KD-tree", ->
      expect(tree).to.be.instanceof KDtree
      #console.log require('util').inspect tree.getRoot(), colors: true, depth: 5

    it "should have the root at x = 5", ->
      expect(tree.getRoot().val).to.deep.equal {label: 'b', x:5, y:2, z:7}

    it "should have the correct first left child", ->
      expect(tree.getRoot().left.val).to.deep.equal {label: 'c', x:3, y:3, z:4}

    it "should have the correct right left child", ->
      expect(tree.getRoot().right.val).to.deep.equal {label: 'g', x:5, y:3, z:7}

    it "should have the complete correct tree", ->
      expect(tree.getRoot().left.left.val).to.deep.equal {label: 'a', x:1, y:2, z:3}
      expect(tree.getRoot().left.right.val).to.deep.equal {label: 'h', x:3, y:9, z:9}
      expect(tree.getRoot().right.left.val).to.deep.equal {label: 'f', x:10, y:1, z:3}
      expect(tree.getRoot().right.right.val).to.deep.equal {label: 'i', x:8, y:8, z:8}
      expect(tree.getRoot().right.left.left.val).to.deep.equal {label: 'e', x:9, y:0, z:1}
      expect(tree.getRoot().right.right.left.val).to.deep.equal {label: 'd', x:5, y:5, z:5}

  describe "querying k-Nearest Neighbors", ->
    describe 'with basic testCase', ->
      testCase = require './test-cases/simple'
      objects = testCase.objects
      profile1 = testCase.subject1
      profile2 = testCase.subject2
      profile3 = testCase.subject3
      options = k: 3
      tree = new KDtree objects, (k for k,v of profile1) # so we neglect label as a dimension

      console.log '       --- TEST CASE ---'
      console.log testCase.chart

      it "should return an instance of KD-tree", ->
        expect(tree).to.be.instanceof KDtree
        #console.log require('util').inspect tree.getRoot(), colors: true, depth: 5

      it 'should return the nearest neighbor', ->
        tree.query(profile1).label.should.eql('C')
        tree.query(profile2).label.should.eql('E')
        tree.query(profile3).label.should.eql('J')
