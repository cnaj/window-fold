{CompositeDisposable} = require 'atom'
util = require 'util'

module.exports = WindowFold =
  disposables: null

  activate: (state) ->
    console.log 'WindowFold was activated'

    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-workspace',
      'window-fold:toggle': => @toggle()

  deactivate: ->
    @disposables.dispose()

  serialize: ->

  toggle: ->
    pane = atom.workspace.getActivePane()
    element = atom.views.getView(pane)

    elementBox = getElementBox element
    if not @origElementBox
      console.log "activate WindowFold"
      @origElementBox = elementBox
      @origWindowBox = getWindowBox()
    else
      windowBox = getWindowBox()

      # x,y of element in screen coordinates (w/o border)
      posAbsOld = add @origWindowBox, @origElementBox
      posAbsCur = add windowBox, elementBox

      posDelta = sub posAbsOld, posAbsCur
      sizeDelta = sizeDiff @origElementBox, elementBox

      unless isZero(posDelta) and isZero(sizeDelta)
        console.log "need to move window by #{util.inspect posDelta}"
        move windowBox, posDelta
        console.log "need to resize window by #{util.inspect sizeDelta}"
        resize windowBox, sizeDelta

        atom.setPosition windowBox.x, windowBox.y
        atom.setSize windowBox.width, windowBox.height
      else
        console.log "deactivate WindowFold"
        @origElementBox = null
        @origWindowBox = null

getElementBox = (element) ->
  x = y = 0
  el = element
  while el
    x += el.offsetLeft
    y += el.offsetTop
    root = el unless el.parentElement
    el = el.parentElement
  {x, y, width: element.offsetWidth, height: element.offsetHeight}

getWindowBox = ->
  pos = atom.getPosition()
  size = atom.getSize()
  {x: pos.x, y: pos.y, width: size.width, height: size.height}

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
