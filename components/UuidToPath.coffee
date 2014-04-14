noflo = require 'noflo'

class UuidToPath extends noflo.Component
  description: ''
  constructor: ->
    @inPorts =
      in: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'string'

    @inPorts.in.on 'data', (uuid) =>
      return unless @outPorts.out.isAttached()
      arr1 = uuid.split('-')
      arr2 = arr1.map((el) ->
        (parseInt(el, 16) % 65535).toString(16))
      ret = '/' + arr2.join('/')
      @outPorts.out.send(ret)
    @inPorts.in.on 'disconnect', () =>
      @outPorts.out.disconnect() if @outPorts.out.isConnected()

exports.getComponent = -> new UuidToPath
