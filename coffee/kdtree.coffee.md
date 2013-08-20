KD-tree
-------------------

A KD-tree implementation for performing lightning-fast k-NN queries on. For both building and querying, the algorithm alternates between dimensions in a round-robin fashion. When performing queries, it assumes the presence of the query object attributes in all node leafs.

Sources [1](http://andrewd.ces.clemson.edu/courses/cpsc805/references/nearest_search.pdf), [2](http://www.stanford.edu/class/cs106l/handouts/assignment-3-kdtree.pdf), and [3](http://en.wikipedia.org/wiki/K-d_tree)

#### Building the tree:

The constructor of the KD-tree expects an array of objects which have the same attributes. Optionally as a second argument, you may provide an array of attribute keys you would like to index.

    class KDtree
      getRoot: () ->
        @_tree

      constructor: (@objects, @keys) ->
        @keys ?= (k for k,v of @objects[0])

Looping over each attribute in a round-robin fashion, do the following:

 - If there is no objects left, do nothing
 - Otherwise, sort the objects by next dimension in `@attr`, and split through the median
 - Create a node, store current object and recursively build up the tree for the left and the right set

        _helper = (objects, depth) =>
          return null unless objects.length

`depth` determines which attribute we are splitting by

          len = @keys.length
          key = @keys[depth % len]

To find the node we split through, we sort the objects and find the median. However, it is possible that the nodes left to the median has the same value as the median, resulting in an inconsistent split -- so we need to find the index to split by, which would be the lowest index of the median value.

          objects.sort (a,b) -> a[key] - b[key]
          medianVal = objects[Math.floor objects.length / 2][key]
          median = (v[key] for v in objects).indexOf medianVal

Now store the current object in `val` of the splitting node, and recursively build up the left and right branches of the tree and increasing the depth.

          node =
            val: objects[median]
            left: _helper(objects.slice(0,median), depth + 1)
            right: _helper(objects.slice(median + 1), depth + 1)

With our `_helper` function defined, we can now trigger the tree to be build.

        @_tree = _helper @objects, 0

    module.exports = KDtree
