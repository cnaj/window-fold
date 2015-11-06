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
      posAbsOld = addPos @origWindowBox, @origElementBox
      posAbsCur = addPos windowBox, elementBox

      posDelta = subPos posAbsOld, posAbsCur
      sizeDelta = subSize @origElementBox, elementBox

      unless posDelta.isZero() and sizeDelta.isZero()
        console.log "need to move window by #{util.inspect posDelta}"
        windowBox.move posDelta
        console.log "need to resize window by #{util.inspect sizeDelta}"
        windowBox.resize sizeDelta

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
  new Box x, y, element.offsetWidth, element.offsetHeight

getWindowBox = ->
  pos = atom.getPosition()
  size = atom.getSize()
  new Box pos.x, pos.y, size.width, size.height

addPos = (a, b) ->
  new Vec a.x + b.x, a.y + b.y

subPos = (a, b) ->
  new Vec a.x - b.x, a.y - b.y

subSize = (a, b) ->
  new Vec a.width - b.width, a.height - b.height

class Vec
  constructor: (@x, @y) ->

  isZero: ->
    @x == 0 && @y == 0

  equals: (other) ->
    @x == other.x && @y == other.y

class Box
  constructor: (@x, @y, @width, @height) ->

  move: (delta) ->
    @x += delta.x
    @y += delta.y

  resize: (delta) ->
    @width += delta.x
    @height += delta.y

  equals: (other) ->
    @x == other.x &&
      @y == other.y &&
      @width == other.width &&
      @height == other.height
