noflo = require 'noflo'

class BuildFilePath extends noflo.Component
  description: ''

  constructor: ->
    @inPorts =
      path: new noflo.Port 'string'
      filename: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'string'

    @inPorts.path.on 'data', (path) =>
      @path = path
    @inPorts.filename.on 'data', (filename) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.send(@path + '/' + filename)
    @inPorts.filename.on 'disconnect', () =>
      @outPorts.out.disconnect() if @outPorts.out.isConnected()

exports.getComponent = -> new BuildFilePath
