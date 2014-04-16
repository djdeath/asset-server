noflo = require 'noflo'

class FileSchema extends noflo.Component
  description: ''
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.in.on 'begingroup', (group) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', (connection) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.send @getSchema(connection)
    @inPorts.in.on 'endgroup', () =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', () =>
      return unless @outPorts.out.isConnected()
      @outPorts.out.disconnect()

  getSchema: (connection) ->
    return connection.Schema
      addedDate: Date
      itemCount: Number
      name: String

exports.getComponent = -> new FileSchema
