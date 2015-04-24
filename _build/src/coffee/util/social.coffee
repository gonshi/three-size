instance = null

class Social
  exec: ->
    type = {}
    for i in [ 0...arguments.length ]
      type[ arguments[ i ] ] = true

    # facebook
    if type.fb?
      fjs = document.getElementsByTagName( "script" )[ 0 ]
      return if document.getElementById "facebook-jssdk"
      js = document.createElement "script"
      js.id = "facebook-jssdk"
      js.src = "//connect.facebook.net/ja_JP/sdk.js#xfbml=1&" +
              "appId=1427692494204579&version=v2.0"
      fjs.parentNode.insertBefore js, fjs
    
    # twitter
    if type.tweet?
      window.twttr = (->
        fjs = document.getElementsByTagName( "script" )[ 0 ]
        return if document.getElementById "twitter-wjs"
        js = document.createElement "script"
        js.id = "twitter-wjs"
        js.src = "https://platform.twitter.com/widgets.js"
        fjs.parentNode.insertBefore js, fjs
        if window.twttr?
          return window.twttr
        else
          return ( t =
            _e: []
            ready:  ( f )-> t._e.push f
          )
      )()

    # hatena
    if type.hatena?
      j = document.createElement "script"
      j.type = "text/javascript"
      j.src = "https://b.st-hatena.com/js/bookmark_button.js"
      j.async = "async"
      j.charset = "utf-8"
      s = document.getElementsByTagName( "script" )[0]
      s.parentNode.insertBefore j, s

    # pocket
    if type.pocket?
      if !document.getElementById "pocket-btn-js"
        j = document.createElement "script"
        j.id = "pocket-btn-js"
        j.type = "text/javascript"
        j.src = "https://widgets.getpocket.com/v1/j/btn.js?v=1"
        w = document.getElementById "pocket-btn-js"
        document.body.appendChild j

    # gplus
    if type.gplus?
      po = document.createElement "script"
      po.type = "text/javascript"
      po.async = true
      po.src = "https://apis.google.com/js/plusone.js"
      s = document.getElementsByTagName( "script" )[0]
      s.parentNode.insertBefore po, s

    # fb-share
    $( document ).on "click", ".fb-share button", ( e )->
      window.FB.ui
        method: "share"
        href: window.location.href

  callback: ->
    # twitter
    window.twttr.ready ( twttr )->
      twttr.events.bind "tweet", ->
        _callback "tw"

    # facebook like
    window.onload = ->
      window.FB.Event.subscribe "edge.create",
        ( response )->
          _callback "fb" if response

    _callback = ( type )->
      console.log type

getInstance = ->
  if !instance
    instance = new Social()
  return instance

module.exports = getInstance
