###!
  * Main Function
###

if window._DEBUG
  if Object.freeze?
    window.DEBUG = Object.freeze window._DEBUG
  else
    window.DEBUG = state: true
else
  if Object.freeze?
    window.DEBUG = Object.freeze state: false
  else
    window.DEBUG = state: false

ticker = require( "./util/ticker" )()

$ ->
  $top = $( ".girl .top" )
  $middle = $( ".girl .middle" )
  $bottom = $( ".girl .bottom" )

  ticker.listen "slot", ( t )->
    $top.attr "data-size": ( parseInt( t / 100 ) % 3 ) + 1
    $middle.attr "data-size": ( parseInt( t / 80 ) % 3 ) + 1
    $bottom.attr "data-size": ( parseInt( t / 120 ) % 3 ) + 1

  if ( ( /android/i ).test( window.navigator.userAgent ) )
    window.onload = ->
      document.body.style.zoom = window.innerWidth / 640
