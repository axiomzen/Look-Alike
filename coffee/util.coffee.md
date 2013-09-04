Utilities
-------------------------

####  Euclidean distance function

Takes 2 objects, and returns Euclidean distance based on the first object attributes
e.g. p1 = {a: 1} and p2 = {a: 2, b: 3, c: 5} will ignore extra attributes on p2 and return 1
All attributes on p1 MUST be present in p2 (otherwise will be inaccurate if ignored)
Accepts optional third argument, which is an options hash:
 - [stdv] defines the stdv for each attr
 - [weights] defines the weights for each attr

    exports.distance = (p1, p2, opts) ->
      dist = 0
      for attr, val of p1
        x = val
        y = p2[attr]

        # Normalize if stdv values are passed in opts
        if opts?.stdv and Object.getOwnPropertyNames(opts.stdv).length > 0
          x /= opts.stdv[attr]
          y /= opts.stdv[attr]

        # Apply weight factor is provided
        if opts?.weights and Object.getOwnPropertyNames(opts.weights).length > 0
          x *= opts.weights[attr]
          y *= opts.weights[attr]

        dist += Math.pow x - y, 2
      Math.sqrt dist

####  Standard Deviation

Given an array of numbers, returns the stdv
Given an array of objects, require key parameter identifying the attribute to calculate stdv for

    exports.stdv = (array, key) ->
      if typeof array[0] != 'number' and not key
        throw new Error('No key parameter provided')

      arr = []
      if key
        arr = (a[key] for a in array)
      else
        arr = array

      m = mean(arr)
      ssqdiff = 0
      for x in arr
        ssqdiff += Math.pow( x - m, 2)
      Math.sqrt(ssqdiff / array.length)

#### Get all Standard Deviations

Given an array of attributes and an array of objects, return an object describing the stdv per attribute.

    exports.allStdvs = (attributes, objects, key) ->
      stdvs = {}
      objects = (key(o) for o in objects) if key
      for attr in attributes
        stdvs[attr] = exports.stdv(objects, attr)
      stdvs

#### Get index of the median

Given an array of sorted numbers, return the index bounds of the median value.

    exports.medianIndex = (array) ->
      median = Math.floor array.length / 2
      medianVal = array[median]
      lower: array.indexOf medianVal
      upper: array.lastIndexOf(medianVal) + 1
      median: median

#### Get splits from sorted array of objects and median bounds

Given an array of sorted objects and the median bounds, return object with an array of identical objects and arrays of remaining objects for left and right.

    exports.getSplit = (objects, bounds, attributes, current_attr, key = (o) -> o) ->
      medianObj = objects[bounds.median]
      identicals = (obj: o, ind: i for o,i in objects when attributes.every (a) -> key(medianObj)[a] is key(o)[a])
      pickedIndices = (x.ind for x in identicals)

      identicals: (x.obj for x in identicals)
      left: (o for o,i in objects when key(o)[current_attr] < key(medianObj)[current_attr] and i not in pickedIndices)
      right: (o for o,i in objects when key(o)[current_attr] >= key(medianObj)[current_attr] and i not in pickedIndices)


#### ---  meta-utils  ---

    mean = (array) ->
      sum = array.reduce (a,b) -> a + b
      sum / array.length
