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

require "../js/velocity.min.js"
ticker = require( "./util/ticker" )()
resizeHandler = require( "./controller/resizeHandler" )()
sizeData = require( "./model/sizeData" )()
imgData = require( "./model/imgData" )()

$ ->
  #####################################
  # DECLARATION
  #####################################

  $top = $( ".girl .parts.top" )
  $middle = $( ".girl .parts.middle" )
  $bottom = $( ".girl .parts.bottom" )
  $girl = $( ".girl" )
  $boy = $( ".boy" )
  $value = $( ".girl .value" )
  $result = $( ".result_container" )
  $pic = $( ".result .pic" )
  $again = $( ".result_container .again" )
  chara_scale = null

  chara_next = null
  sex_next = null
  selected =
    top: false
    middle: false
    bottom: false

  size_anchor =
    top: [ 85, 80 ]
    middle: [ 65, 60 ]
    bottom: [ 88, 84 ]

  size_stat =
    top:
      min: 75
      range: 35
    middle:
      min: 52
      range: 33
    bottom:
      min: 80
      range: 30

  MIN_HEIGHT = 900

  _count = 0 # プレゼン用

  #####################################
  # PRIVATE
  #####################################
  
  _setNextChara = ->
    _count += 1
    if _count == 3
      sex_next = "chara"
    else if _count == 4
      sex_next = "man"
    else if _count == 6
      sex_next = "other"
    else
      sex_next = "woman"
    _index = Math.floor( Math.random() * window.size[ sex_next ].length )
    chara_next = window.size[ sex_next ][ _index ]
    window.size[ sex_next ].splice _index, 1

  #####################################
  # EVENT LISTENER
  #####################################

  ticker.listen "checkLoad", ->
    if window.size.woman?
      ticker.clear "checkLoad"
      $( ".girl .guard" ).hide()
      _setNextChara()

      ticker.listen "slot", ( t )->
        if !selected.top
          $top.attr "data-size": ( parseInt( t / 100 ) % 3 ) + 1
        if !selected.middle
          $middle.attr "data-size": ( parseInt( t / 80 ) % 3 ) + 1
        if !selected.bottom
          $bottom.attr "data-size": ( parseInt( t / 120 ) % 3 ) + 1

  $( ".girl .parts" ).on "click", ->
    _type = $( this ).data "type"
    _$value = $( ".girl .value.#{ _type }" )
    _$value.find( ".length" ).text chara_next[ _type ]
    selected[ _type ] = true

    # サイズの画を描画
    for i in [ 0...size_anchor[ _type ].length ]
      if parseInt( chara_next[ _type ] ) > size_anchor[ _type ][ i ]
        $( this ).attr "data-size": i + 1
        break
      else if i == size_anchor[ _type ].length - 1
        $( this ).attr "data-size": i + 1

    _scale = 1 + ( chara_next[ _type ] - size_stat[ _type ].min ) /
             size_stat[ _type ].range
    _scale = 2 if _scale > 2

    _$value.velocity
      opacity: 1
      translateX: 40 * _scale
      scale: _scale
    , 400, "spring"

    # 3つそろった
    if selected.top && selected.middle && selected.bottom
      setTimeout (-> $boy.addClass "think" ), 1000
      $result.find( ".name" ).text chara_next.name
      imgData.getData chara_next.name

      # 考えるポーズの時間しばらく待機
      _addWait = if _count == 1 then 1000 else 0
      setTimeout ->
        if sex_next == "man"
          $boy.removeClass( "think" ).addClass( "surprised" ).velocity
            translateX: -80
            scale: chara_scale
          , 400, "spring"
        else # woman or other
          $boy.removeClass( "think" ).addClass( "happy" ).velocity
            translateX: -80
            translateY: -20
            scale: chara_scale
          , 300
          
        $result.show().velocity
          opacity: 1
          translateX: 30
        , 1000

        # もう一度ボタンは遅れて表示
        $again.delay( 2000 ).velocity
          opacity: 1
          scale: 1 / 0.8
        , 300, "spring"
      , 2500 + Math.random() * 1500 + _addWait

  resizeHandler.listen "RESIZED", ->
    _win_height = $( window ).height()
    if _win_height < MIN_HEIGHT
      chara_scale = _win_height / MIN_HEIGHT
    else
      chara_scale = 1
    $girl.velocity scale: chara_scale, 1
    $boy.velocity scale: chara_scale, 1

  imgData.listen "IMG_LOADED", ( results )->
    for i in [ 0...results.length ]
      $pic.eq( i ).css
        "background-image": "url(#{ results[ i ].tbUrl })"

  $again.on "click", ->
    # reset
    $boy.removeClass().addClass( "boy" ).velocity
      translateX: 0
      translateY: 0
    , 50
    _setNextChara()

    $value.velocity
      opacity: 0
      translateX: 0
      scale: 1

    $result.velocity
      opacity: 0
      translateX: 0
    , ->
      $result.hide()
      # スロット再起動
      selected =
        top: false
        middle: false
        bottom: false

    $again.velocity
      opacity: 0
      scale: 1

    $pic.css "background-image": "none"

  #####################################
  # INIT
  #####################################
  
  sizeData.getData()
  resizeHandler.exec()
  resizeHandler.dispatch "RESIZED", resizeHandler

  if ( ( /android/i ).test( window.navigator.userAgent ) )
    window.onload = ->
      document.body.style.zoom = window.innerWidth / 640
