# Naio
Build system for node.js native addons

***This will only build c/c++ files in `src` directory.***

# Install
`npm i --save naio nan`

# Example
[naio-test](https://github.com/wilhelmmatilainen/naio-test)

# How to use
***Check out the example above***

1. Install
2. Add to package.json
  1. "libraries": ["v8", "all-other-libraries-you-need"]
  2. "scripts": {"build": "make -f node_modules/naio/makefile", "postinstall": "npm run build"}
3. Execute `npm run build`
4. Now you can require/import like this
  1. var mylibrary = require('./build/debug.node') // or release.node
  2. import mylibrary from './build/debug.node'; // or release.node
