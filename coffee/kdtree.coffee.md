KD-tree
-------------------

A KD-tree implementation for performing lightning-fast k-NN queries on. For both building and querying, the algorithm alternates between dimensions in a round-robin fashion. When performing queries, it assumes the presence of the query object attributes in all node leafs.

Sources [1](http://andrewd.ces.clemson.edu/courses/cpsc805/references/nearest_search.pdf), [2](http://www.stanford.edu/class/cs106l/handouts/assignment-3-kdtree.pdf), and [3](http://en.wikipedia.org/wiki/K-d_tree)

#### Building the tree:

The constructor of the KD-tree expects an array of objects which have the same attributes. Optionally as a second argument, you may provide an array of attribute keys you would like to index.

    util = require './util'

    class KDtree
      getRoot: () ->
        @_tree

      constructor: (@objects, @attributes, @options) ->

Parameter checking:

        throw new Error('Need at least 1 argument') unless arguments.length > 0

        if Array.isArray @objects
          if @objects.some((x) -> x and x.toString() isnt '[object Object]')
            throw new Error('Expecting an array of objects as first argument')
        else
          throw new Error('Expecting an array of objects as first argument')

Default `@attributes` to first the keys of the first object. If `@attributes` is passed as a parameter, make sure it is an array of strings.

        @attributes ?= (k for k,v of @objects[0])

        if Array.isArray(@attributes)
          if @attributes.some((x) -> typeof x isnt 'string')
            throw new Error('Expecting an array of strings as second argument')
        else
          throw new Error 'Expecting an array of strings as second argument'

Make sure that all objects have the `@attributes`

        unless @objects.every((x) =>
          @attributes.every((k) =>
            if @options?.key
              @options.key(x).hasOwnProperty k
            else
              x.hasOwnProperty k))

          throw new Error "Expecting all objects to have at least the same keys as first object or second parameter"

We precalculate the Standard Deviations for each attribute, so we can perform standardized queries.

        @stdv = util.allStdvs @attributes, @objects

Looping over each attribute in a round-robin fashion, do the following:

 - If there is no objects left, do nothing
 - Otherwise, sort the objects by next dimension in `@attributes`, and split through the median
 - Create a node, store current object and recursively build up the tree for the left and the right set

        _helper = (objects, depth) =>
          return null unless objects.length

`depth` determines which attribute we are splitting by.

          len = @attributes.length
          attr = @attributes[depth % len]

To find the node we split through, we sort the objects and find the median. However, it is possible that the nodes left to the median has the same value as the median, resulting in an inconsistent split -- so we need to find the index to split by, which would be the lowest index of the median value. If we have a key function, apply it. The latter is useful of we have an object where the relevant attributes are nested in some other object.

          objects.sort (a,b) ->
            if @options?.key
              @options.key(a)[attr] - @options.key(b)[attr]
            else
              a[attr] - b[attr]

          medianVal = objects[Math.floor objects.length / 2][attr]
          median = (v[attr] for v in objects).indexOf medianVal

Now store the current object in `val` of the splitting node, and recursively build up the left and right branches of the tree and increasing the depth.

          node =
            val: objects[median]
            left: _helper(objects.slice(0,median), depth + 1)
            right: _helper(objects.slice(median + 1), depth + 1)

With our `_helper` function defined, we can now trigger the tree to be build.

        @_tree = _helper @objects, 0

#### Querying the tree:

Now that we have our KD-tree fully built, we are ready to perform Nearest Neighborhood queries. We will use a Bounded Priority Queue to store the best nodes found so far. The size of this queue is passed as the second parameter in the query call. The query call expects the following parameters:

  - Subject[Object] - The reference point that we want to find the Nearest Neighbors of -- must have all `@attributes` defined.
  - Options[Object] which may include:
    - k[Int](default = 1) - The number of objects to return. The query complexity is `k log n`, so the higher this number, the longer the algorithm takes (on average).
    - normalize[Bool](default = true) - When true, will normalize the attributes when calculating distances (recommended if attributes are not on the same scale).
    - weights[Object] (optional) - Define weights per attribute (e.g. `{x:0.3, y:0.7}` would weight attribute `y` at 70% and `x` at 30%. Defaults to equal weights)
    - filter[Function] (optional) - When provided, only consider objects in the tree that pass the filter function (i.e. return true)

      query: (subject, options) ->

Make sure the subject has all parameters of `@attributes`

        throw new Error "Subject does not have all keys" unless @attributes.every (k) -> subject.hasOwnProperty k

Default options when not provided

        if options
          options.k = 1 unless options.k
          options.normalize = true unless options.normalize is false
        else
          options = {k:1, normalize: true}

Initialize a BPQ with size `k`.

        BPQ = require './bpq'
        Q = new BPQ options.k

        _helper = (node, depth) =>
          return null unless node

`depth` determines which attribute we are checking now. Apply `key` function if applicable.

          len = @attributes.length
          attr = @attributes[depth % len]
          objectValues = if @options?.key then @options?.key(node.val) else node.val

 - Insert the current node into the queue, with priority being the distance between point and subject. If normalize is true (default), then calculate distances with standard deviations. When weights are given, they will be applied in `util.distance`. If `weights` is undefined, it will be ignored.

          if options.normalize
            dist = util.distance subject, objectValues, stdv: @stdv, weights: options.weights
          else
            dist = util.distance subject, objectValues, weights: options.weights

 - If we have a filter, we would only insert the node into the queue if it passes the filter (i.e. returns true)

          options = options || {}
          if (not options.filter) or options.filter node.val
            Q.insert node.val, dist

 - Recursively search the half of the tree that contains the test point (on the next dimension)

          goLeft = subject[attr] < objectValues[attr]
          if goLeft
            _helper node.left, depth + 1
          else
            _helper node.right, depth + 1

 - Calculate the distance between the current node and the subject along the current dimension. Normalize and apply weights if necessary.

          if options.normalize
            attr_dist = Math.abs(objectValues[attr] - subject[attr]) / @stdv[attr]
          else
            attr_dist = Math.abs(objectValues[attr] - subject[attr])

          if options.weights
            attr_dist *= options.weights[attr]

 - If the BPQ is not full yet **or** if the distance between current point and subject along the current dimension is less than the largest distance in our BPQ.

          if options.k > Q.getSize() or attr_dist < Q.getMaxPriority()

 - then recursively search the other half as well (on the next dimension)

            if goLeft
              _helper node.right, depth + 1
            else
              _helper node.left, depth + 1

 - return Q

          Q.getObjects()

Start at the root:

        root = @getRoot()
        if root is null then return [] else _helper root, 0

    module.exports = KDtree
