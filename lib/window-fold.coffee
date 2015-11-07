{CompositeDisposable} = require 'atom'
util = require 'util'
FoldCalculator = require './fold-calculator'

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

    elementDim = getElementBox element
    windowDim = getWindowBox()
    if not @calc
      console.log "activate WindowFold"
      @calc = new FoldCalculator elementDim, windowDim
    else
      if @calc.calcDimensions elementDim, windowDim
        console.log "move window to #{util.inspect windowDim}"
        atom.setPosition windowDim.x, windowDim.y
        atom.setSize windowDim.width, windowDim.height
      else
        console.log "deactivate WindowFold"
        @calc = null

getElementBox = (element) ->
  x = y = 0
  el = element
  while el
    x += el.offsetLeft
    y += el.offsetTop
    el = el.parentElement
  {x, y, width: element.offsetWidth, height: element.offsetHeight}

getWindowBox = ->
  pos = atom.getPosition()
  size = atom.getSize()
  {x: pos.x, y: pos.y, width: size.width, height: size.height}
