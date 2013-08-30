should = require('chai').should()
utils = require '../coffee/util'

describe 'Euclidean Distance function', ->
  it 'should calculate correctly for 1 dimension', ->
    utils.distance({ a: 1 }, { a: 5 }).should.eql(4)
  it 'should calculate correctly for 2 dimensions', ->
    utils.distance({ a: 1, b: 3 }, { a: 5, b: 5 }).should.eql(Math.sqrt 20)
  it 'should calculate correctly for 3 dimensions', ->
    utils.distance({ a: 1, b: 3 , c: -2}, { a: 5, b: 5, c: 2 }).should.eql(Math.sqrt 36)

describe 'Standard Deviation', ->
  it 'should be 0 with array of equal numbers', ->
    utils.stdv([1, 1, 1, 1, 1])
      .should.eql(0)
  it 'should calculate stdv given an array of numbers', ->
    utils.stdv([600, 470, 170, 430, 300])
      .should.eql(147.32277488562318)
  it 'should also accept objects with a key', ->
    utils.stdv([{ a: 600 },{ a: 470 },{ a: 170 },{ a: 430 },{ a: 300 }], 'a')
      .should.eql(147.32277488562318)
  it 'should not accept objects without a key', ->
    (->
      utils.stdv([{ a: 600 },{ a: 470 },{ a: 170 },{ a: 430 },{ a: 300 }])
    ).should.throw 'No key parameter provided'

describe 'Standard Deviations on data', ->
  it 'should be able to construct an object describing each attribute\'s stdv', ->
    utils.allStdvs(["a", "b"], [{ a: 1, b: 3 }, { a: 5, b: 5 }, { a: 9, b: 7 }])
      .should.eql({ a: Math.sqrt(32/3), b: Math.sqrt(8/3) })

describe 'Standardized Euclidean Distance function', ->
  it 'should accept 2 objects and the stdv for 1 dimension', ->
    utils.distance({ a: 1 }, { a: 5 }, { stdv: { a: 2 } }).should.eql(2)
  it 'should calculate correctly for 2 dimensions', ->
    utils.distance({ a: 1, b: 30 }, { a: 5, b: 50 }, { stdv: { a: 2, b: 10 } }).should.eql(Math.sqrt 8)

describe 'Get median index', ->
  it 'should find the median in a simple array', ->
    utils.medianIndex([1,2,3,4,5]).should.eql 2
  it 'should find the index of the first occurence of the median value', ->
    utils.medianIndex([1,2,3,3,3,3,3,3,4,5]).should.eql 2
