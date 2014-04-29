// Server
var http = require('http');
var runtime = require('noflo-runtime-websocket');

var baseDir = process.env.PROJECT_HOME || 'asset-server'; //process.cwd();
var port = 5555;

var server = http.createServer(function () {});
var rt = runtime(server, {
    baseDir: baseDir,
    captureOutput: false,
    catchExceptions: true
});

server.listen(port, function () {
    console.log('Asset server runtime listening for NoFlo UI at ws://0.0.0.0:' + port);
    console.log('Using ' + baseDir + ' for component loading');
});
