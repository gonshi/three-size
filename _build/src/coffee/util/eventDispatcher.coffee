class EventDispatcher
  constructor: ->
    @listeners = {}
    @dispatched = {}

  listen: ( eventName, callback )->
    if @listeners[ eventName ]?
      @listeners[ eventName ].push callback
    else
      @listeners[ eventName ] = [ callback ]

  dispatch: ( eventName, opt_this, arg... )->
    if @listeners[ eventName ]
      for listener in @listeners[ eventName ]
        listener.apply opt_this || @, arg

  first: ( eventName, opt_this, arg... )->
    if @listeners[ eventName ] &&
       !@dispatched[ eventName ]?
      @dispatched[ eventName ] = true
      for listener in @listeners[ eventName ]
        listener.apply opt_this || @, arg

  clear: ( eventName )->
    @listeners[ eventName ] = null

module.exports = EventDispatcher
