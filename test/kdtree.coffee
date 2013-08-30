expect = require('chai').expect
should = require('chai').should()
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
    tree = new KDtree [{x:2, y:3}, {x:5,y:4}, {x:9,y:6}, {x:4,y:7}, {x:8,y:1}, {x:7,y:2}], attributes: ["x", "y"]
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
    tree = new KDtree [{x:1,y:2,z:3, label:'a'}, {x:5,y:2,z:7, label:'b'}, {x:3,y:3,z:4, label:'c'}, {x:5,y:5,z:5, label:'d'}, {x:9,y:0,z:1, label:'e'}, {x:10,y:1,z:3, label:'f'}, {x:5,y:3,z:7, label:'g'}, {x:3,y:9,z:9, label:'h'}, {x:8,y:8,z:8, label:'i'}], attributes: ["x", "y", "z"]
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

  describe "arguments", ->
    it "should have at least 1 argument", ->
      (-> new KDtree ).should.throw 'Need at least 1 argument'

    it "for the constructor should expect array of objects as first argument", ->
      (-> new KDtree {a:1, b:2, c:3}).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree "bla").should.throw "Expecting an array of objects as first argument"
      (-> new KDtree null).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree undefined).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [2,3,4]).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [{a:2},{b:3},4]).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [[2],[3],[4]]).should.throw "Expecting an array of objects as first argument"
      (-> new KDtree [null,undefined,[4]]).should.throw "Expecting an array of objects as first argument"

    it "should expect the second argument to be an array of strings", ->
      (-> new KDtree [{a:1}], attributes: "bla").should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: {a: 2}).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: 2).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: [2]).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: [null]).should.throw "Expecting an array of strings for attributes"
      (-> new KDtree [{a:1}], attributes: [{a:2}]).should.throw "Expecting an array of strings for attributes"

    it "should expect all objects to have (at least) the same keys as the first object", ->
      (-> new KDtree [{a:1},{a:2},{b:3}]).should.throw "Expecting all objects to have at least the same keys as first object or second parameter"

    it "should expect all objects to have (at least) the keys that are specified in second argument", ->
      (-> new KDtree [{a:1, b:2},{a:2, b:5},{b:3}], attributes: ['a']).should.throw "Expecting all objects to have at least the same keys as first object or second parameter"

  describe "stack overflow", ->
    testCase = require './test-cases/simple'
    objects = testCase.objects
    # Since we have 12 objects, doubling it up 12 times gives up ~50k rows
    for i in [1..12]
      objects = objects.concat objects

    it "should be able to handle ~50k rows without throwing SO", ->
      console.log "Building tree with #{objects.length} number of rows"
      tree = new KDtree objects
      expect(tree).to.be.instanceof KDtree

    it "should be able to handle ~100k rows without throwing SO", ->
      objects = objects.concat objects
      console.log "Building tree with #{objects.length} number of rows"
      tree = new KDtree objects
      expect(tree).to.be.instanceof KDtree

    it "should be able to handle ~200k rows without throwing SO", ->
      objects = objects.concat objects
      console.log "Building tree with #{objects.length} number of rows"
      tree = new KDtree objects
      expect(tree).to.be.instanceof KDtree
