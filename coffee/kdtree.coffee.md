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

      constructor: (@objects, @options) ->

Parameter checking:

        throw new Error('Need at least 1 argument') unless arguments.length > 0

        if Array.isArray @objects
          if @objects.some((x) -> x and x.toString() isnt '[object Object]')
            throw new Error('Expecting an array of objects as first argument')
        else
          throw new Error('Expecting an array of objects as first argument')

Default `@options.attributes` to first the keys of the first object. If `@options.attributes` is passed as a parameter, make sure it is an array of strings.

        @options = @options or {}
        @options.attributes ?= (k for k,v of @objects[0])

        if Array.isArray(@options.attributes)
          if @options.attributes.some((x) -> typeof x isnt 'string')
            throw new Error('Expecting an array of strings for attributes')
        else
          throw new Error 'Expecting an array of strings for attributes'

Make sure that all objects have the `@options.attributes`

        unless @objects.every((x) =>
          @options.attributes.every((k) =>
            if @options.key
              @options.key(x).hasOwnProperty k
            else
              x.hasOwnProperty k))

          throw new Error "Expecting all objects to have at least the same keys as first object or second parameter"

We precalculate the Standard Deviations for each attribute, so we can perform standardized queries.

        @stdv = util.allStdvs @options.attributes, @objects, @options.key

Looping over each attribute in a round-robin fashion, do the following:

 - If there is no objects left, do nothing
 - Otherwise, sort the objects by next dimension in `@options.attributes`, and split through the median
 - Create a node, store current object and recursively build up the tree for the left and the right set

        _helper = (objects, depth) =>
          return null unless objects.length

`depth` determines which attribute we are splitting by.

          len = @options.attributes.length
          attr = @options.attributes[depth % len]

To find the node we split through, we sort the objects and find the median. If we have a key function, apply it. The latter is useful of we have an object where the relevant attributes are nested in some other object.

          objects.sort (a,b) ->
            if @options?.key
              @options.key(a)[attr] - @options.key(b)[attr]
            else
              a[attr] - b[attr]

In order to handle cases where we have multiple points on the same spot, we want to combine identical objects in an array. Many identical objects can result in very deep trees, resulting in imbalance and stack overflows. The `medianIndex` will return the lower and upper bounds of the array between which the current attribute has same value. `getSplit` will return an object that contains an array of identical objects (compared to the median object) and splits for left and right branch.


          temp = objects
          temp = (@options.key(o) for o in objects) if @options.key
          bounds = util.medianIndex (o[attr] for o in temp)
          splits = util.getSplit objects, bounds, @options.attributes, attr, @options.key

Now store the current array of objects in `val` of the splitting node, and recursively build up the left and right branches of the tree and increasing the depth.

          node =
            val: splits.identicals
            left: _helper(splits.left, depth + 1)
            right: _helper(splits.right, depth + 1)

With our `_helper` function defined, we can now trigger the tree to be build.

        @_tree = _helper @objects, 0

#### Querying the tree:

Now that we have our KD-tree fully built, we are ready to perform Nearest Neighborhood queries. We will use a Bounded Priority Queue to store the best nodes found so far. The size of this queue is passed as the second parameter in the query call. The query call expects the following parameters:

  - Subject[Object] - The reference point that we want to find the Nearest Neighbors of -- must have all `@options.attributes` defined.
  - Options[Object] which may include:
    - `k[Int] (default = 1)` - The number of objects to return. The query complexity is `k log n`, so the higher this number, the longer the algorithm takes (on average).
    - `normalize[Bool] (default = true)` - When true, will normalize the attributes when calculating distances (recommended if attributes are not on the same scale).
    - `weights[Object] (optional)` - Define weights per attribute (e.g. `{x:0.3, y:0.7}` would weight attribute `y` at 70% and `x` at 30%. Defaults to equal weights)
    - `filter[Function] (optional)` - When provided, only consider objects in the tree that pass the filter function (i.e. return true)

      query: (subject, options) ->

Make sure the subject has all parameters of `@options.attributes`

        throw new Error "Subject does not have all keys" unless @options.attributes.every (k) -> subject.hasOwnProperty k

Default options when not provided

        if options
          options.k = 1 unless options.k
          options.normalize = true unless options.normalize is false
        else
          options = {k:1, normalize: true}

Initialize a BPQ with size `k`.

        BPQ = require './bpq'
        Q = new BPQ options.k
        count = 0

        _helper = (node, depth) =>
          return null unless node
          count++

`depth` determines which attribute we are checking now. Apply `key` function if applicable.

          len = @options.attributes.length
          attr = @options.attributes[depth % len]
          objectValues = if @options?.key then @options?.key(node.val[0]) else node.val[0]

 - Insert the current node into the queue, with priority being the distance between point and subject. If normalize is true (default), then calculate distances with standard deviations. When weights are given, they will be applied in `util.distance`. If `weights` is undefined, it will be ignored.

          if options.normalize
            dist = util.distance subject, objectValues, stdv: @stdv, weights: options.weights
          else
            dist = util.distance subject, objectValues, weights: options.weights

 - If we have a filter, we would only insert the node into the queue if it passes the filter (i.e. returns true)
 - node.val is an array that contain multiple objects with identical attributes -- they need to be filtered individually.

          options = options || {}
          if options.filter
            for o in node.val
              Q.insert o, dist if options.filter o
          else
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
        ans = if root is null then [] else _helper root, 0
        console.log count + " recursions"
        ans

    module.exports = KDtree
