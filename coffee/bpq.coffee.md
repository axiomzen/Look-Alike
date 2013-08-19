Bounded Priority Queue
-----------

A naive implementation for a (Min) Priority Queue with an upper-bound. Will maintain the max size while replacing the object in the queue with highest priority.

#### Instance methods:

- insert(object, priority) - Inserts object in priority queue.
- getMaxPriority( ) - Returns the largest priority in queue.
- getMinPriority( ) - Returns the smallest priority in queue.
- getObjects( ) - Returns Array of all objects in queue -- length depends on size upon construction.

#### Code:

Class definition with some "private" variables

    Heap = require 'heap'

    class BPQ
      _cmp = (a, b) -> a.priority - b.priority

**constructor**: (size) - Returns an instance of BPQ with maximum length of _size_. Stores `@size` and @queue as instance variables.

      constructor: (@size) ->
        @queue = new Heap _cmp

**insert**: (obj, priority) - Inserts the object onto the heap.

      insert: (obj, priority) ->
        @queue.push
          obj: obj
          priority: priority

**getObjects**: Returns the queue as an Array

      getObjects: () ->
        tmp = Heap.nsmallest @queue.toArray(), @size, _cmp
        (x.obj for x in tmp)

**getMaxPriority**: Returns the value of the highest priority in the queue

      getMaxPriority: () ->
        tmp = Heap.nsmallest @queue.toArray(), @size, _cmp
        tmp.pop().priority

**getMinPriority**: Returns the value of the lowest priority in the queue

      getMinPriority: () ->
        @queue.top().priority

    module.exports = BPQ
