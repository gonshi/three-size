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
require "./model/preload"
ticker = require( "./util/ticker" )()
social = require( "./util/social" )()
resizeHandler = require( "./controller/resizeHandler" )()
sizeData = require( "./model/sizeData" )()
imgData = require( "./model/imgData" )()

$ ->
  #####################################
  # DECLARATION
  #####################################

  $boy = $( ".boy" )

  $girl = $( ".girl" )
  $value = $girl.find( ".value" )
  $top = $girl.find( ".parts.top" )
  $middle = $girl.find( ".parts.middle" )
  $bottom = $girl.find( ".parts.bottom" )

  $noticeContainer = $( ".notice_container" )

  $result_container = $( ".result_container" )
  $pic = $result_container.find( ".pic" )
  $again = $result_container.find( ".again" )
  $social = [
    $result_container.find( ".fb-share" ),
    $result_container.find( ".tweet" ),
    $result_container.find( ".line" )
  ]

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

  is_first = true
  fin_count = 0 # 遊んだ回数

  ORIGINAL_SIZE = []
  MIN_HEIGHT = 900
  DUR = 500

  #####################################
  # PRIVATE
  #####################################

  _setNextChara = ->
    _random = Math.random()
    if _random < 0.1 # 10%
      sex_next = "chara"
    else if _random < 0.2 # 10%
      sex_next = "man"
    else # 80%
      sex_next = "woman"
    _index = Math.floor( Math.random() * window.size[ sex_next ].length )
    chara_next = window.size[ sex_next ][ _index ]
    window.size[ sex_next ].splice _index, 1

    if window.size[ sex_next ].length == 0
      # 全て出し尽くしたらデータを再生
      window.size[ sex_next ] = ORIGINAL_SIZE[ sex_next ].concat()

  #####################################
  # EVENT LISTENER
  #####################################

  ticker.listen "checkLoad", ->
    if window.size.woman?
      for sex of window.size
        ORIGINAL_SIZE[ sex ] = window.size[ sex ].concat()
      ticker.clear "checkLoad"
      $girl.find( ".guard" ).hide()
      _setNextChara()

      ticker.listen "slot", ( t )->
        if !selected.top
          $top.attr "data-size": ( parseInt( t / 100 ) % 3 ) + 1
        if !selected.middle
          $middle.attr "data-size": ( parseInt( t / 80 ) % 3 ) + 1
        if !selected.bottom
          $bottom.attr "data-size": ( parseInt( t / 120 ) % 3 ) + 1

  # 18歳以上ですをクリック
  $noticeContainer.find( ".notice-yes" ).on "click", ->
    $noticeContainer.velocity
      opacity: 0
    , ->
      $noticeContainer.hide()
      # 一定時間以上クリックされなければ、アドバイス吹き出しを表示
      setTimeout ->
        for i of selected
          return if selected[ i ]
        $( ".girl .advice" ).show().velocity
          opacity: 1
          translateX: -30
        setTimeout (-> $( ".girl .advice" ).hide() ), DUR * 8
      , DUR * 4

  # 女性の各パーツをクリック
  $girl.find( ".parts" ).on "click", ->
    _type = $( this ).data "type"
    return if selected[ _type ]
    _$value = $girl.find( ".value.#{ _type }" )
    _$value.find( ".length" ).text chara_next[ _type ]
    if window.isSp
      $result_container.find( ".#{ _type } .length" ).text chara_next[ _type ]
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

    _vec = if window.isSp then -1 else 1
    _$value.velocity
      opacity: 1
      translateX: 40 * _scale * _vec
      scale: _scale
    , DUR, "spring"

    # 3つそろった
    if selected.top && selected.middle && selected.bottom
      fin_count += 1
      window.ga "send", "event", "button",
                "click", "fin-#{ fin_count }", 1 # GA Event
      setTimeout (-> $boy.addClass "think" ), DUR * 2
      $result_container.find( ".name" ).text chara_next.name
      imgData.getData chara_next.name

      # 考えるポーズの時間しばらく待機
      _addWait = if is_first then DUR else 0 # 1回目は少し考える時間長く見せる
      is_first = false
      setTimeout ->
        _vec = if window.isSp then 0 else 1
        if sex_next == "man"
          $boy.removeClass( "think" ).addClass( "surprised" ).velocity
            translateX: -80 * _vec
            scale: chara_scale
          , DUR, "spring"
        else # woman or other
          $boy.removeClass( "think" ).addClass( "happy" ).velocity
            translateX: -80 * _vec
            translateY: -20
            scale: chara_scale
          , DUR / 2

        $result_container.show().velocity
          opacity: 1
          translateX: 30
        , DUR * 2

        $value.velocity opacity: 0, DUR / 2 if window.isSp

        # もう一度ボタン, SNSボタンは遅れて表示
        _x = if window.isSp then 30 else 0
        for i in [ 0...$social.length ]
          $social[ i ].delay( DUR * 3.4 + ( i * 0.2 ) * DUR ).velocity
            opacity: 1
            scale: [ 1, 0.8 ]
          , DUR, "spring"
        $again.delay( DUR * 4 ).velocity
          opacity: 1
          scale: [ 1, 0.8 ]
          translateX: _x
        , DUR, "spring"
      , DUR * 5 + Math.random() * DUR * 3 + _addWait

  resizeHandler.listen "RESIZED", ->
    _win_height = $( window ).height()
    if window.isSp
      chara_scale = 0.8
    else if _win_height < MIN_HEIGHT
      chara_scale = _win_height / MIN_HEIGHT
    else
      chara_scale = 1

    if !window.isSp
      $girl.velocity scale: chara_scale, 30
    $boy.velocity scale: chara_scale, 30

  imgData.listen "IMG_LOADED", ( results )->
    for i in [ 0...results.length ]
      $pic.eq( i ).css
        "background-image": "url(#{ results[ i ].image.thumbnailLink})"

  # reset
  $again.on "click", ->
    $boy.removeClass().addClass( "boy" ).velocity
      translateX: 0
      translateY: 0
    , 50
    _setNextChara()

    $value.velocity
      opacity: 0
      translateX: 0
      scale: 1

    $result_container.velocity
      opacity: 0
      translateX: 0
    , ->
      $result_container.hide()
      # スロット再起動
      selected =
        top: false
        middle: false
        bottom: false

    for i in [ 0...$social.length ]
      $social[ i ].velocity opacity: 0, 50
    $again.velocity opacity: 0, 50

    $pic.css "background-image": "none"

  #####################################
  # INIT
  #####################################

  sizeData.getData()
  resizeHandler.exec()
  resizeHandler.dispatch "RESIZED", resizeHandler
  social.exec "fb", "tweet"

  if window.isAndroid
    _zoom = window.innerWidth / 640
    window.onload = -> document.body.style.zoom = _zoom

    # css calc bug fix
    $result_container.find( ".pic_container" ).css
      height: $( window ).height() / _zoom * 0.85 * 0.8 * 0.81 - 71

  if window.isSp
    $( ".girl .advice" ).html(
      $( ".girl .advice" ).html().replace( "クリック", "タップ" ) )

  if window.location.hash == "#skip" # three codesから飛んできた場合
    $( ".notice_container .notice-yes" ).trigger "click"
