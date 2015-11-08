module.exports =
class FoldCalculator

  constructor: (elementDim, windowDim) ->
    @borders = new Borders elementDim, windowDim

  calcDimensions: (elementDim_, windowDim_) ->
    elementDim = cloneDim elementDim_
    windowDim = cloneDim windowDim_

    borders = new Borders elementDim_, windowDim_
    delta = borders.getDelta(@borders)

    # calculate corrections for window

    if delta.left isnt 0
      # panel opened to the left
      windowDim.x -= delta.left
      windowDim.width += delta.left
      elementDim.width += delta.left
    if delta.right isnt 0
      # panel opened to the right
      windowDim.width += delta.right
      elementDim.width += delta.right

    if delta.top isnt 0
      # panel opened to the top
      windowDim.y -= delta.top
      windowDim.height += delta.top
      elementDim.height += delta.top
    if delta.bottom isnt 0
      # panel opened to the bottom
      windowDim.height += delta.bottom
      elementDim.height += delta.bottom

    unless equalsDim(windowDim_, windowDim)
      @borders = new Borders elementDim, windowDim
      windowDim
    else
      null

class Borders
  constructor: (elementDim, windowDim) ->
    @left   = elementDim.x
    @top    = elementDim.y
    @right  = windowDim.width - elementDim.width - @left
    @bottom = windowDim.height - elementDim.height - @top

  getDelta: (other) =>
    {
      left:   @left   - other.left
      right:  @right  - other.right
      top:    @top    - other.top
      bottom: @bottom - other.bottom
    }

# dimension operations

cloneDim = (dim) ->
  {x: dim.x, y: dim.y, width: dim.width, height: dim.height}

equalsDim = (a, b) ->
  a.x == b.x and a.y == b.y and
    a.width == b.width and a.height == b.height
