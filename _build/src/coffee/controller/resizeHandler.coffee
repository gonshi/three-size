EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class ResizeHandler extends EventDispatcher
  constructor: ->
    super()

  exec: ->
    throttle = new Throttle 300

    $( window ).on "resize", =>
      throttle.last => @dispatch "RESIZED", this

  off: -> $( window ).off "resize"

getInstance = ->
  if !instance
    instance = new ResizeHandler()
  return instance

module.exports = getInstance
