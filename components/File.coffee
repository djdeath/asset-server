noflo = require 'noflo'

class File extends noflo.Component
  description: ''
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
      filename: new noflo.Port 'string'
      addeddate: new noflo.Port 'object'
      updateddate: new noflo.Port 'object'
      mime: new noflo.Port 'string'
      path: new noflo.Port 'string'
      tags: new noflo.Port 'array'
      done: new noflo.Port 'bang'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.in.on 'data', (obj) =>
      @obj = obj

    @connectPort('filename')
    @connectPort('path')
    @connectPort('mime')
    @connectPort('tags')
    @connectPort('addeddate', 'addedDate')
    @connectPort('updateddate', 'updatedDate')

    @inPorts.done.on 'begingroup', (group) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.beginGroup group
    @inPorts.done.on 'data', (group) =>
      return unless @obj
      return unless @outPorts.out.isAttached()
      @outPorts.out.send @obj
    @inPorts.done.on 'endgroup', () =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.endGroup()
    @inPorts.done.on 'disconnect', () =>
      return unless @outPorts.out.isConnected()
      @outPorts.out.disconnect()
      delete @obj

  connectPort: (portName, property) ->
    property = portName unless property?
    @inPorts[portName].on 'data', (data) =>
      return unless @obj?
      @obj[property] = data

exports.getComponent = -> new File
