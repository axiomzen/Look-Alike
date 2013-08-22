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
    getLabels = (results) ->
      (r.label for r in results)

    describe 'with 3D testCase', ->
      tree = new KDtree [{x:1,y:2,z:3, label:'a'}, {x:5,y:2,z:7, label:'b'}, {x:3,y:3,z:4, label:'c'}, {x:5,y:5,z:5, label:'d'}, {x:9,y:0,z:1, label:'e'}, {x:10,y:1,z:3, label:'f'}, {x:5,y:3,z:7, label:'g'}, {x:3,y:9,z:9, label:'h'}, {x:8,y:8,z:8, label:'i'}], ["x", "y", "z"]
      profile =
        x: 3
        y: 3
        z: 3

      it "should return the nearest neighbor", ->
        tree.query(profile, normalize: false)[0].label.should.eql 'c'

      it 'should return 3 nearest neighbors, sorted by distance', ->
        getLabels(tree.query(profile, k: 3, normalize: false)).should.eql(['c', 'a', 'd'])

      it 'should return all objects sorted by distance', ->
        getLabels(tree.query(profile, k: 20, normalize: false)).should.eql \
        ['c', 'a', 'd', 'g', 'b', 'e', 'f', 'h', 'i']

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
        #console.log tree.query(profile1)
        tree.query(profile1, normalize: false)[0].label.should.eql('C')
        tree.query(profile2, normalize: false)[0].label.should.eql('E')
        tree.query(profile3, normalize: false)[0].label.should.eql('J')

      it 'should return 3 nearest neighbors, sorted by distance', ->
        getLabels(tree.query(profile1, k: 3, normalize: false)).should.eql(['C', 'H', 'A'])
        getLabels(tree.query(profile2, k: 3, normalize: false)).should.eql(['E', 'F', 'A'])
        getLabels(tree.query(profile3, k: 3, normalize: false)).should.eql(['J', 'L', 'G'])

      it 'should return all objects sorted by distance', ->
        getLabels(tree.query(profile1, k: 20, normalize: false)).should.eql \
        ['C', 'H', 'A', 'E', 'K', 'F', 'D', 'I', 'G', 'B', 'L', 'J']
        getLabels(tree.query(profile2, k: 20, normalize: false)).should.eql \
        ['E', 'F', 'A', 'H', 'G', 'D', 'C', 'I', 'K', 'J', 'B', 'L']
        getLabels(tree.query(profile3, k: 20, normalize: false)).should.eql \
        ['J', 'L', 'G', 'I', 'F', 'D', 'E', 'B', 'H', 'K', 'A', 'C']

    describe 'with testCase that requires normalization', ->
      testCase = require './test-cases/standardize'
      objects = testCase.objects
      profile1 = testCase.subject1
      profile2 = testCase.subject2
      profile3 = testCase.subject3
      options = k: 3
      tree = new KDtree objects, (k for k,v of profile1) # so we neglect label as a dimension

      it "should return an instance of KD-tree", ->
        expect(tree).to.be.instanceof KDtree
        #console.log require('util').inspect tree.getRoot(), colors: true, depth: 5

      it 'should return the nearest neighbor', ->
        #console.log tree.query(profile1)
        tree.query(profile1)[0].label.should.eql('C')
        tree.query(profile2)[0].label.should.eql('E')
        tree.query(profile3)[0].label.should.eql('J')

      it 'should return 3 nearest neighbors, sorted by distance', ->
        getLabels(tree.query(profile1, k: 3)).should.eql(['C', 'H', 'A'])
        getLabels(tree.query(profile2, k: 3)).should.eql(['E', 'F', 'A'])
        getLabels(tree.query(profile3, k: 3)).should.eql(['J', 'L', 'G'])

      it 'should return all objects sorted by distance', ->
        getLabels(tree.query(profile1, k: 20)).should.eql \
        ['C', 'H', 'A', 'E', 'K', 'F', 'D', 'I', 'G', 'B', 'L', 'J']
        getLabels(tree.query(profile2, k: 20)).should.eql \
        ['E', 'F', 'A', 'H', 'G', 'D', 'C', 'I', 'K', 'J', 'B', 'L']
        getLabels(tree.query(profile3, k: 20)).should.eql \
        ['J', 'L', 'G', 'I', 'F', 'D', 'E', 'B', 'H', 'K', 'A', 'C']

      describe 'and weights per attribute', ->
        it 'should minimize category with 0.01 weight', ->
          options = k:3, standardize: true, weights: { attr_a: 0.01, attr_b: 0.99 }
          getLabels(tree.query(profile1, options)).should.eql(['K', 'C', 'H'])
          getLabels(tree.query(profile2, options)).should.eql(['E', 'A', 'I'])
          getLabels(tree.query(profile3, options)).should.eql(['B', 'J', 'L'])
