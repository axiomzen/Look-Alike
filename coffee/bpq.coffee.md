Bounded Priority Queue
-----------

A naive implementation for a (Min) Priority Queue with an upper-bound. Will maintain the max size while replacing the object in the queue with highest priority.

#### Instance methods:

- insert(object, priority) - Inserts object in priority queue if it is lower than the max priority in queue.
- getMaxPriority( ) - Returns the largest priority in queue.
- getMinPriority( ) - Returns the smallest priority in queue.
- getObjects( ) - Returns Array of all objects in queue.


**constructor**: (size) - Returns an instance of BPQ with maximum length of _size_

    class BPQ
      @_queue: []

      constructor: (size) ->
        @_size = size

    module.exports = BPQ
