noflo = require 'noflo'
mongoose = require 'mongoose'

class FileSchema extends noflo.Component
  description: ''
  constructor: ->
    @inPorts =
      in: new noflo.Port 'bang'
    @outPorts =
      out: new noflo.Port 'object'

    @inPorts.in.on 'begingroup', (group) =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.beginGroup group
    @inPorts.in.on 'data', () =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.send @getSchema()
    @inPorts.in.on 'endgroup', () =>
      return unless @outPorts.out.isAttached()
      @outPorts.out.endGroup()
    @inPorts.in.on 'disconnect', () =>
      return unless @outPorts.out.isConnected()
      @outPorts.out.disconnect()

  getSchema: () ->
    return @schema if @schema?
    @schema = new mongoose.Schema
      id: String
      addedDate: Date
      itemCount: Number

exports.getComponent = -> new FileSchema
