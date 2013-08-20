KD-tree
-------------------

A KD-tree implementation for performing lightning-fast k-NN queries on. For both building and querying, the algorithm alternates between dimensions in a round-robin fashion. When performing queries, it assumes the presence of the query object attributes in all node leafs.

Sources [1](http://andrewd.ces.clemson.edu/courses/cpsc805/references/nearest_search.pdf), [2](http://www.stanford.edu/class/cs106l/handouts/assignment-3-kdtree.pdf), and [3](http://en.wikipedia.org/wiki/K-d_tree)

#### Building the tree:

The constructor of the KD-tree expects an array of objects which have the same attributes. Optionally as a second argument, you may provide an array of attribute keys you would like to index.

    class KDtree
      getRoot: () ->
        @_tree

      constructor: (@objects, keys) ->
        keys ?= (k for k,v of @objects[0])
        @_tree = _helper @objects, keys, 0

Looping over each attribute in a round-robin fashion, do the following:

 - If there is no objects left, do nothing
 - Otherwise, sort the objects by next dimension in `@attr`, and split through the median
 - Create a node, store current object and recursively build up the tree for the left and the right set

      _helper = (objects, keys, depth) ->
        return null unless objects.length
        len = keys.length
        key = keys[depth % len]
        objects.sort (a,b) -> a[key] - b[key]
        median = Math.floor objects.length / 2
        node =
          val: objects[median]
          left: _helper(objects.slice(0,median), keys, depth + 1)
          right: _helper(objects.slice(median + 1), keys, depth + 1)


    module.exports = KDtree
