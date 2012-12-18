/* HTTP interface to JSPath.

   Invoke from bash script like:

     curl --form querypath="${2}" --form source="<${1}" --form filename="${1}" ${JSPATH_URL}

   or use the provided jspath.curl

     jspath.curl <file>

*/
var express = require("express");
var JSPath  = require('jspath');
var app     = express();

app.configure(function () {
    app.use(
        express.errorHandler(
            { dumpExceptions: true, showStack: true }
        )
    );
    app.use(express.bodyParser());
});

var jsp_port = 3005;

app.get('/', function (req, res) {
    res.send('jspath-mode');
});

app.post('/query', function (req, res) {
    res.set('Content-Type', 'application/json');
    res.send(JSPath.apply(req.body.querypath, JSON.parse(req.body.source)));
});

function parseCommandLine() {
    var port_index, properties;
    port_index = process.argv.indexOf('--port');
    if (port_index > -1) {
        jsp_port = process.argv[port_index + 1];
    }
}

process.on('SIGINT', function () {
    console.log("\n[jspath-mode] received SIGINT, shutting down");
    process.exit(0);
});

parseCommandLine();
app.listen(jsp_port, function () {
    console.log("[jspath-mode] server running on port", jsp_port);
});
