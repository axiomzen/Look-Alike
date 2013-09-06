expect = require('chai').expect
should = require('chai').should()
KDtree = require '../coffee/kdtree'

describe 'KD-tree simple queries', ->
  it 'should return an empty object/array if no objects', ->
    tree = new KDtree []
    expect(tree.query({a:1})).to.eql([])
  it 'should return nearest neighbor with single dimension', ->
    tree = new KDtree [{a:1}, {a:2}]
    expect(tree.query(a:1)).to.eql([{a:1}])
  it 'should return 2 nearest neighbors (in order) with single dimension', ->
    tree = new KDtree [{a:1}, {a:3}, {a:0}]
    expect(tree.query(a:1, {k:2})).to.eql([{a:1}, {a:0}])
  it 'should expect the keys in subject to be present in all objects', ->
    tree = new KDtree [{a:1}, {a:3}, {a:0}]
    expect(-> (tree.query b:1)).to.throw 'Subject does not have all keys'

  it 'should accept a key parameter for objects', ->
    key = (o) -> o.x
    tree = new KDtree [{x: {a:1}}, {x: {a:2}}, {x: {a:3}}], {attributes: ['a'], key: key}
    # console.log require('util').inspect tree, colors: true, depth: 8
    expect(tree.query(a:1, {k: 1, normalize: false})).to.eql([{x: {a:1}}])
  it 'should accept a key parameter for nested objects', ->
    tree = new KDtree [{x: {y: {a:1}}}, {x: {y: {a:2}}}], {attributes: ['a'], key: (o) -> o.x.y}
    expect(tree.query(a:1, {k: 1, normalize: false})).to.eql([{x: {y: {a:1}}}])
  it 'should accept filter parameter', ->
    tree = new KDtree [{a:1}, {a:3}, {a:0}], attributes: ['a']
    expect(tree.query(a:1, {k: 2, normalize: false, filter: (o) -> o.a > 0})).to.eql([{a:1}, {a:3}])
  it 'should accept return empty array if filters all', ->
    tree = new KDtree [{a:1}, {a:3}, {a:0}], attributes: ['a']
    expect(tree.query(a:1, {k: 2, normalize: false, filter: (o) -> o.a > 10})).to.eql([])

describe "querying k-Nearest Neighbors on a KDtree", ->
  getLabels = (results) ->
    (r.label for r in results)

  describe 'with 3D testCase', ->
    tree = new KDtree [{x:1,y:2,z:3, label:'a'}, {x:5,y:2,z:7, label:'b'}, {x:3,y:3,z:4, label:'c'}, {x:5,y:5,z:5, label:'d'}, {x:9,y:0,z:1, label:'e'}, {x:10,y:1,z:3, label:'f'}, {x:5,y:3,z:7, label:'g'}, {x:3,y:9,z:9, label:'h'}, {x:8,y:8,z:8, label:'i'}], attributes: ["x", "y", "z"]
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
    tree = new KDtree objects, attributes: (k for k,v of profile1) # so we neglect label as a dimension

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
    tree = new KDtree objects, attributes: (k for k,v of profile1) # so we neglect label as a dimension

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

describe.skip "Benchmarking multi-dimensional data, standardize and a lot of duplicate points ", ->
  testCase = require './test-cases/large'
  objects3 = testCase.objects3
  objects4 = testCase.objects4
  objects5 = testCase.objects5
  profile3 = testCase.subject3
  profile4 = testCase.subject4
  profile5 = testCase.subject5
  tree3 = {}
  tree4 = {}
  tree5 = {}
  for x in [1..12]
    objects3 = objects3.concat objects3
    objects4 = objects4.concat objects4
    objects5 = objects5.concat objects5

  it "build 3d tree with #{objects3.length} number of rows", ->
    tree3 = new KDtree objects3, attributes: (k for k,v of profile3)

  it "build 4d tree with #{objects3.length} number of rows", ->
    tree4 = new KDtree objects4, attributes: (k for k,v of profile4)

  it "build 5d tree, with key parameter with #{objects3.length} number of rows", ->
    tree5 = new KDtree objects5, attributes: (k for k,v of profile5), key: (o) -> o.vals

  it "3-dimensional large-scale query", ->
    tree3.query(profile3, k:8000, standardize: true, weights: { attr_a: 0.3, attr_b: 0.3, attr_c: 0.4 })

  it "4-dimensional large-scale query", ->
    tree4.query(profile4, k:8000, standardize: true, weights: { attr_a: 0.3, attr_b: 0.3, attr_c: 0.3, attr_d: 0.1 })

  it "5-dimensional large-scale query", ->
    tree5.query(profile5, k:8000, standardize: true, weights: { attr_a: 0.2, attr_b: 0.3, attr_c: 0.3, attr_d: 0.1, attr_e: 0.1 })

describe "Benchmarking multi-dimensional data, large-scale randomized with overlap", ->
  objects = []
  for x in [0..50000]
    objects.push
      a: Math.floor(Math.random() * 5)
      b: Math.floor(Math.random() * 5)
      c: Math.floor(Math.random() * 5)
      d: Math.floor(Math.random() * 5)
      e: Math.floor(Math.random() * 5)
      data: "Some random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is random data that is.. "
      more: Math.random()
  subject = objects.pop()
  tree3 = {}
  tree4 = {}
  tree5 = {}
  tree6 = {}
  it "build 3d tree with #{objects.length} number of rows", ->
    tree3 = new KDtree objects, attributes: ["a", "b", "c"]
  it "build 4d tree with #{objects.length} number of rows", ->
    tree4 = new KDtree objects, attributes: ["a", "b", "c", "d"]
  it "build 5d tree with #{objects.length} number of rows", ->
    tree5 = new KDtree objects, attributes: ["a", "b", "c", "d", "e"]
  it "build 6d tree with #{objects.length} number of rows", ->
    tree6 = new KDtree objects, attributes: ["a", "b", "c", "d", "e", "more"]
    #console.log require('util').inspect tree.getRoot(), colors: true, depth: 5
  it "3-dimensional large-scale query to get top 10000", ->
    tree3.query(subject, k:10000, standardize: true, weights: { a: 0.2, b: 0.3, c: 0.4})
  it "4-dimensional large-scale query to get top 10000", ->
    tree4.query(subject, k:10000, standardize: true, weights: { a: 0.2, b: 0.3, c: 0.3, d: 0.2})
  it "5-dimensional large-scale query to get top 10000", ->
    tree5.query(subject, k:10000, standardize: true, weights: { a: 0.2, b: 0.3, c: 0.3, d: 0.1, e: 0.1 })
  it "6-dimensional large-scale query to get top 10000", ->
    tree6.query(subject, k:10000, standardize: true, weights: { a: 0.2, b: 0.3, c: 0.2, d: 0.1, e: 0.1, more: 0.1 })
