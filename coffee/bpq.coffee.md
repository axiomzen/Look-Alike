Bounded Priority Queue
-----------

A naive implementation for a (Min) Priority Queue with an upper-bound. Will maintain the max size while replacing the object in the queue with highest priority.

#### Instance methods:

- insert(object, priority) - Inserts object in priority queue if it is lower than the max priority in queue.
- getMaxPriority( ) - Returns the largest priority in queue.
- getMinPriority( ) - Returns the smallest priority in queue.
- getObjects( ) - Returns Array of all objects in queue.

#### Code:

Class definition with some "private" variables

    class BPQ
      _queue: []
      _bound: Infinity

**constructor**: (size) - Returns an instance of BPQ with maximum length of _size_

      constructor: (@size) ->

**insert**: (obj, priority) - Inserts the object into the queue, only if the priority is lower than the highest priority already in the queue. If so, the highest priority in the queue will be replaced with the new object.

      insert: (obj, priority) =>
        if priority < @_bound
          @_queue.push
            obj: obj
            priority: priority

**getObjects**: Returns the queue as an Array

      getObjects: () ->
        (x.obj for x in @_queue)

**getMaxPriority**: Returns the value of the highest priority in the queue

      getMaxPriority: () ->
        Math.max.apply null, (x.priority for x in @_queue)

**getMinPriority**: Returns the value of the highest priority in the queue

      getMinPriority: () ->
        Math.min.apply null, (x.priority for x in @_queue)

    module.exports = BPQ
