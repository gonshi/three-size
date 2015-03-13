class CanvasManager
  constructor: ( $dom )->
    @canvas = $dom.get 0
    if !@canvas.getContext
      return undefined
    @context = @canvas.getContext "2d"

  resetContext: ( width, height )->
    @canvas.width = width
    @canvas.height = height

  clear: -> @context.clearRect 0, 0, @canvas.width, @canvas.height

  getImgData: ( x, y, width, height )->
    @context.getImageData x, y, width, height

  getImg: -> @canvas.toDataURL()

  getContext: -> @context

module.exports = CanvasManager
