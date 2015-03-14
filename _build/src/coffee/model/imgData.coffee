EventDispatcher = require( "../util/eventDispatcher" )

instance = null

class ImgData extends EventDispatcher
  constructor: ->
    super()

  getData: ( query )->
    $.ajax
      type: "get"
      url: "https://www.googleapis.com/customsearch/v1?" +
           "key=AIzaSyDnLFO5WKX6LPVO4yEDZGsAqGIPVos-Gow&" +
           "cx=016489218282066124601:rfqomcxwe0w&q=" +
           "#{ encodeURIComponent query }" +
           "&searchType=image&num=4"
    .done ( data )=>
      @dispatch "IMG_LOADED", this, data.items

getInstance = ->
  if !instance
    instance = new ImgData()
  return instance

module.exports = getInstance
