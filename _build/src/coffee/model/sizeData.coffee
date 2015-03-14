# spread sheet API callback
_partsExp =
  top: /バスト: (.*?),/
  middle: /ウエスト: (.*?),/
  bottom: /ヒップ: (.*?),/
  
_sexExp = /性別: (.*?)$/

window.gdata = {}
window.gdata.io = {}
window.size = {} # 取得データを格納

window.gdata.io.handleScriptLoaded = ( response )->
  _length = response.feed.entry.length
  for i in [ 0..._length ]
    _sex = response.feed.entry[ i ].content.$t.match( _sexExp )[ 1 ]
    window.size[ _sex ] = [] if typeof window.size[ _sex ] != "object"
    _index = window.size[ _sex ].length
    window.size[ _sex ][ _index ] = {}
    window.size[ _sex ][ _index ].name = response.feed.entry[ i ].title.$t
    for e of _partsExp
      window.size[ _sex ][ _index ][ e ] =
        response.feed.entry[ i ].content.$t.match( _partsExp[ e ] )[ 1 ]

instance = null

class SizeData
  getData: ->
    @src = "https://spreadsheets.google.com/feeds/list" +
           "/1yjXNRJ2xGtyTN6d97pjDH3SZhdwbnVBvQVT9ydu2qi0" +
           "/od6/public/basic?alt=json-in-script"
    $( "head" ).append( $( "<script>" ).attr src: @src )

getInstance = ->
  if !instance
    instance = new SizeData()
  return instance

module.exports = getInstance
