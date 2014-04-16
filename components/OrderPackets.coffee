noflo = require 'noflo'

class OrderPackets extends noflo.Component
  description: ''
  constructor: ->
    @inPorts =
      in: new noflo.Port 'all'
    @outPorts =
      out1: new noflo.Port 'all'
      out2: new noflo.Port 'all'

    @inPorts.in.on 'begingroup', (group) =>
      @outPorts.out1.beginGroup group
      @outPorts.out2.beginGroup group
    @inPorts.in.on 'data', (data) =>
      @outPorts.out1.send data
      @outPorts.out2.send data
    @inPorts.in.on 'endgroup', () =>
      @outPorts.out1.endGroup()
      @outPorts.out2.endGroup()
    @inPorts.in.on 'disconnect', () =>
      @outPorts.out1.disconnect()
      @outPorts.out2.disconnect()

exports.getComponent = -> new OrderPackets
