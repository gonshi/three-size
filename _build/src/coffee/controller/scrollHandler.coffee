EventDispatcher = require "../util/eventDispatcher"
Throttle = require "../util/throttle"
instace = null
  
class ScrollHandler extends EventDispatcher
  constructor: ->
    super()

  exec: ->
    throttle = new Throttle 100

    $( document ).on "scroll", =>
      throttle.exec => @dispatch "SCROLLED", this

  off: -> $( document ).off "scroll"

getInstance = ->
  if !instance
    instance = new ScrollHandler()
  return instance

module.exports = getInstance
