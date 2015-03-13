PI = Math.PI
sin = Math.sin

window.easeOutQuad = ( current_t, from, to, duration )->
  return to * sin( current_t / duration * ( PI / 2 ) ) + from

window.easeInQuad = ( current_t, from, to, duration )->
  current_t /= duration
  return to * current_t * current_t + from

window.easeInBack = ( current_t, from, to, duration )->
  s = 1.70158
  return to * ( current_t /= duration ) * current_t *
         ( ( s + 1 ) * current_t - s ) + from

window.easeOutBack = ( current_t, from, to, duration )->
  s = 1.70158
  return to * ( ( current_t = current_t / duration - 1 ) *
         current_t * ( ( s + 1 ) * current_t + s ) + 1 ) + from
