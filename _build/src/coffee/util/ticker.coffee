instance = null

class Ticker
  if window.performance?.now?
    window.getNow = -> window.performance.now()
  else
    window.getNow = -> Date.now()

  if window.requestAnimationFrame?
    window.requestAnimFrame = window.requestAnimationFrame
  else if window.webkitRequestAnimationFrame?
    window.requestAnimFrame = window.webkitRequestAnimationFrame
  else if window.mozRequestAnimationFrame?
    window.requestAnimFrame = window.mozRequestAnimationFrame
  else
    window.requestAnimFrame =
      ( callback )-> window.setTimeout callback, 1000 / 60

  constructor: ->
    @listeners = {}
    @start = {}

    ################################
    # PRIVATE
    ################################
    _renderer = =>
      for name of @listeners
        @listeners[ name ]( getNow() - @start[ name ] )
      window.requestAnimFrame _renderer

    _renderer()

  listen: ( name, func )->
    @start[ name ] = window.getNow()
    @listeners[ name ] = func

  clear: ( name )->
    if name?
      delete @listeners[ name ]
      delete @start[ name ]
    else
      @listeners = {}
      @start = {}

getInstance = ->
  if !instance
    instance = new Ticker()
  return instance

module.exports = getInstance
