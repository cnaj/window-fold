module.exports =
class FoldCalculator

  constructor: (@elementDim, @windowDim) ->

  calcDimensions: (elementDim, windowDim) ->
    # x,y of element in screen coordinates (w/o border)
    posAbsOld = add @windowDim, @elementDim
    posAbsCur = add windowDim, elementDim

    posDelta = sub posAbsOld, posAbsCur
    sizeDelta = sizeDiff @elementDim, elementDim

    unless isZero(posDelta) and isZero(sizeDelta)
      move windowDim, posDelta
      resize windowDim, sizeDelta
      true
    else
      false

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
