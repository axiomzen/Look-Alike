Bounded Priority Queue
-----------

A naive implementation for a (Min) Priority Queue with an upper-bound. Will maintain the max size while replacing the object in the queue with highest priority. TODO: Performance can be improved by using a heap.

#### Instance methods:

- insert(object, priority) - Inserts object in priority queue if it is lower than the max priority in queue.
- getMaxPriority( ) - Returns the largest priority in queue.
- getMinPriority( ) - Returns the smallest priority in queue.
- getObjects( ) - Returns Array of all objects in queue.

#### Code:

Class definition with some "private" variables

    class BPQ
      _bound = -1

**constructor**: (size) - Returns an instance of BPQ with maximum length of _size_. Stores `@size` and @queue as instance variables.

      constructor: (@size) ->
        @queue = []

**insert**: (obj, priority) - Inserts the object into the queue, only if the priority is lower than the highest priority already in the queue. If so, the highest priority in the queue will be replaced with the new object.

      insert: (obj, priority) =>

If the queue is not full yet, we can just push the object in the queue and set `_bound` if the new priority is larger than current `_bound`. Resort `@queue` to maintain order.

        if @queue.length < @size
          @queue.push
            obj: obj
            priority: priority
          _bound = priority if priority > _bound
          @queue.sort (a,b) -> a.priority - b.priority

If the queue is full, we need to find the object with the highest priority and swap it out for the new object -- and set the new `_bound`. Only if the priority of the new object is smaller than the current max priority, will we do this.

        else if priority < _bound
          @queue[@size - 1] =
            obj: obj
            priority: priority
          _bound = priority
          @queue.sort (a,b) -> a.priority - b.priority

**getObjects**: Returns the queue as an Array

      getObjects: () ->
        (x.obj for x in @queue)

**getMaxPriority**: Returns the value of the highest priority in the queue

      getMaxPriority: () ->
        Math.max.apply null, (x.priority for x in @queue)

**getMinPriority**: Returns the value of the highest priority in the queue

      getMinPriority: () ->
        Math.min.apply null, (x.priority for x in @queue)

    module.exports = BPQ
