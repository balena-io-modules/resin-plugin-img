resin-plugin-img
----------------

[![npm version](https://badge.fury.io/js/resin-plugin-img.svg)](http://badge.fury.io/js/resin-plugin-img)
[![dependencies](https://david-dm.org/resin-io/resin-plugin-img.png)](https://david-dm.org/resin-io/resin-plugin-img.png)

Modify a resin device image before burning it.

Installation
------------

Install `resin-plugin-img` by running:

```sh
$ npm install -g resin-cli resin-plugin-img
```

You can then access the `resin img` command from your terminal.

Documentation
-------------

The only supported subcommand currently is "cp".

It allows copying files from your local filesystem to a path in the boot partition.

###Usage###
resin img cp &lt;image> &lt;from> &lt;to>

 * image: Path to a resin device disk image.
 * from: Path in your local filesystem to copy from.
 * to: Path in the boot partition of the disk to copy to.

###Example###

```resin img cp resin-myApp-0.0.1.img deviceTree.dtb /dtbs/deviceTree.dtb```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/resin-plugin-img/issues/new) on GitHub and the Resin.io team will be happy to help.

Contribute
----------

- Issue Tracker: [github.com/resin-io/resin-plugin-img/issues](https://github.com/resin-io/resin-plugin-img/issues)
- Source Code: [github.com/resin-io/resin-plugin-img](https://github.com/resin-io/resin-plugin-img)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning.

License
-------

The project is licensed under the MIT license.
