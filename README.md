##JSPath-mode

This is an emacs minor mode allowing you to query parts of json files with [JSPath](https://www.github.com/dfilatov/jspath)

It depends on Node.js and on a couple of things from npm, Just check package.json and npm install the right things.

It is basically a copy-pasta of [LintNode](http://www.github.com/davidmiller/lintnode)

###Usage
```shell
$ node app.js --port 3005 &
Express started at http://localhost:3005/ in development mode

$ jspath.curl myjsonfile.json .stuff.from..thefile
```
###Emacs Usage

Check [jspath-mode](http://www.github.com/clodeindustrie/jspath-mode/blob/master/jspath-mode.el)

