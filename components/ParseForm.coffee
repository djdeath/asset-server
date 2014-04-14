noflo = require 'noflo'
formidable = require 'formidable'

class ParseForm extends noflo.Component
  description: ''
  constructor: ->
    @inPorts =
      in: new noflo.Port 'object'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'

    @inPorts.in.on 'data', (request) =>
      form = new formidable.IncomingForm()
      form.parse(request, (error, fields, files) =>
        return @sendError(error) if error
        @sendFiles(request, files))

  sendError: (error) ->
    return unless @outPorts.error.isAttached()
    @outPorts.error.send(error)
    @outPorts.error.disconnect()

  sendFiles: (request, files) ->
    return unless @outPorts.out.isAttached()
    request.files = files
    @outPorts.out.send(request)
    @outPorts.out.disconnect()

exports.getComponent = -> new ParseForm
