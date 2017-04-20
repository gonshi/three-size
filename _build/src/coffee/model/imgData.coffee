EventDispatcher = require( "../util/eventDispatcher" )

instance = null

class ImgData extends EventDispatcher
  constructor: ->
    super()
    window.response = ( data )=>
      @dispatch "IMG_LOADED", this, data.responseData.results

  getData: ( query )->
    $.ajax
      type: "get"
      url: "https://www.googleapis.com/customsearch/v1?" +
           "key=AIzaSyCykbiUpkEiXcmM7OQh_pdT9x7LeQIuj9g&" +
           "cx=009941356438065580846:6dvuyglcydo&q=" +
           "#{ encodeURIComponent query }" +
           "&searchType=image&num=4"
    .done ( data )=>
      @dispatch "IMG_LOADED", this, data.items

    ###
    _src = "http://ajax.googleapis.com/ajax/services/" +
           "search/images?v=1.0&callback=response" +
           "&q=#{ encodeURIComponent query }&start=0&rsz=4"
    $( "head" ).append( $( "<script>" ).attr src: _src )
    ###

getInstance = ->
  if !instance
    instance = new ImgData()
  return instance

module.exports = getInstance
