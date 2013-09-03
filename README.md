Look-Alike
===========
[![Build Status](https://travis-ci.org/axiomzen/Look-Alike.png?branch=master)](https://travis-ci.org/axiomzen/Look-Alike)

Twin brother of [Alike](https://github.com/axiomzen/Alike). They look quite alike. Except this brother is more heavy-weight and likes playing in trees.

A simple-yet-powerful KD-tree library for NodeJS, with support for lightning-fast k-Nearest Neighbour queries. Supports normalization, weights, key and filter parameters.

## Look-Alike vs Alike

But if Look-Alike is more powerful than Alike, why use Alike at all? Well, [TANSTAAFL](http://en.wikipedia.org/wiki/There_ain't_no_such_thing_as_a_free_lunch)

Alike is more nimble and functional and does not require state. You can call it with thousands of rows and it will still be fast (`n log n`). It is also better when the rows change often (no need to rebuild the tree).

Look-Alike builds the tree in advance (which is the only way to beat `n log n`) and holds it in memory. It supports kNN queries that can be as fast as `k log n`, so is the prefered brother when you have more than a few thousand rows. The tree does not change -- it would need to be rebuild (at `n log2 n`) before the query when the rows change.

## Quickstart

To install and add it to your `package.json`

```
$ npm install look-alike --save
```

Now you can load up the module and use it like so:

```javascript
LA = require('look-alike');
tree = new LA([rows]);
top3 = tree.query(subject, {k:3});
```

Given `[rows]` is an array of gazillion objects with `x` numerical attributes, `top3` now holds an array of the 3 closest objects to `subject`. The second-easiest Recommender System you will ever see (aside from [Alike](https://github.com/axiomzen/Alike)).

## Overview

Look-Alike exports a single class with a constructor and a single instance method.

The constructor expects an array of objects, and optionally an object of options:

  - `objects[Array]` - The rows from which we build our tree
  - `options[Object] (optional)` - which may include:
    - `attributes[Array] (optional)` - An array of strings which list attributes/dimensions to use in the KD-tree. By default, will use all keys of the first object in `objects`. Specifying which keys to use for the tree is useful if you want to include additional information in the objects (such as an id, or a label, or more).
    - `key[Function] (optional)` - A `key` function, which is used to map over `objects` to get to the `attributes`. Useful when the attributes are nested in the parent object.


The instance method is called `query` and expects the following parameters:

  - `subject[Object]` - The reference point that we want to find the Nearest Neighbors of
  - `options[Object] (optional)` - which may include:
    - `k[Int] (default = 1)` - The number of objects to return. The query complexity is `k log n`, so the higher this number, the longer the algorithm takes (on average).
    - `normalize[Bool] (default = true)` - When true, will normalize the attributes when calculating distances (recommended if attributes are not on the same scale). Note: turn off for small number of rows to avoid unexpected results! In those cases you should be using [Alike](https://github.com/axiomzen/Alike) anyway!
    - `weights[Object] (optional)` - Define weights per attribute (e.g. `{x:0.3, y:0.7}` would weight attribute `y` at 70% and `x` at 30%. Defaults to equal weights)
    - `filter[Function] (optional)` - When provided, only consider objects in the tree that pass the filter function (i.e. return true)

And returns an array of objects in sorted order. You may look at the test-cases if you don't believe me.


## Development

Look-Alike is written in Literate CoffeeScript in the `coffee/` folder. Browse around on Github for the best annotated source experience!

Unit tests are in the `test/` folder. You can run the tests with `npm test` or if you are developing, you may use `make watch-test` to watch while you TDD. :)

## License

Look-Alike is licensed under the terms of the [GNU Lesser General Public License](http://www.gnu.org/licenses/lgpl.html), known as the LGPL.