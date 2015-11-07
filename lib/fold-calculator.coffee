module.exports =
class FoldCalculator

  constructor: (elementDim, windowDim) ->
    @borders = new Borders elementDim, windowDim

  calcDimensions: (elementDim, windowDim) ->
    borders = new Borders elementDim, windowDim
    delta = borders.getDelta(@borders)

    posDelta = {x: 0, y: 0}
    sizeDelta = {x: 0, y: 0}

    if delta.width == -delta.left
      posDelta.x = delta.width
      sizeDelta.x = -delta.width
    else if delta.width == -delta.right
      sizeDelta.x = -delta.width

    if delta.height == -delta.top
      posDelta.y = delta.height
      sizeDelta.y = -delta.height
    else if delta.height == -delta.bottom
      sizeDelta.y = -delta.height

    unless isZero(posDelta) and isZero(sizeDelta)
      @borders.updateBordersDim posDelta, sizeDelta
      dim = cloneDim windowDim
      move dim, posDelta
      resize dim, sizeDelta
      dim
    else
      null

class Borders
  constructor: (elementDim, windowDim) ->
    @width  = elementDim.width
    @height = elementDim.height

    @left   = elementDim.x
    @top    = elementDim.y
    @right  = windowDim.width - @left - @width
    @bottom = windowDim.height - @top - @height

  getDelta: (other) =>
    {
      width:  @width  - other.width
      height: @height - other.height
      left:   @left   - other.left
      top:    @top    - other.top
      right:  @right  - other.right
    }

  updateBordersDim: (posDelta, sizeDelta) ->
    @left -= posDelta.x
    @top  -= posDelta.y
    @right  = sizeDelta.x + posDelta.x
    @bottom = sizeDelta.y + posDelta.y
    # TODO: respect width change
    # TODO: respect height change

# dimension operations

cloneDim = (dim) ->
  {x: dim.x, y: dim.y, width: dim.width, height: dim.height}

# vector operations on {x, y}

add = (a, b) ->
  x = a.x + b.x
  y = a.y + b.y
  {x, y}

sub = (a, b) ->
  x = a.x - b.x
  y = a.y - b.y
  {x, y}

isZero = (vec) ->
  vec.x == 0 and vec.y == 0

move = (vec, delta) ->
  vec.x += delta.x
  vec.y += delta.y

# size operations on {width, height}

sizeDiff = (a, b) ->
  x = a.width - b.width
  y = a.height - b.height
  {x, y}

resize = (vec, delta) ->
  vec.width += delta.x
  vec.height += delta.y
