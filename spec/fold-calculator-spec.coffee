FoldCalculator = require '../lib/fold-calculator'

describe "FoldCalculator", ->

  describe "when nothing changes", ->

    it "won't resize", ->
      windowDim = dim 200, 100, 300, 500
      elementDim = dim 0, 0, 300, 500

      calc = new FoldCalculator elementDim, windowDim
      expect(windowDim).toEqual dim 200, 100, 300, 500
      expect(elementDim).toEqual dim 0, 0, 300, 500

      newDim = calc.calcDimensions elementDim, windowDim
      expect(newDim).toBe null
      expect(windowDim).toEqual dim 200, 100, 300, 500
      expect(elementDim).toEqual dim 0, 0, 300, 500

  describe "when panel opened left", ->

    it "expands to the left", ->
      calc = new FoldCalculator dim(0, 0, 300, 500), dim(200, 100, 300, 500)

      # panel 100 wide opened to the left
      windowDim = dim(200, 100, 300, 500)
      newDim = calc.calcDimensions dim(100, 0, 200, 500), windowDim
      expect(newDim).toEqual dim 100, 100, 400, 500

      # panel closed again
      newDim = calc.calcDimensions dim(0, 0, 400, 500), newDim
      expect(newDim).toEqual dim 200, 100, 300, 500

      # another calculation after resize won't change nothing
      expect(calc.calcDimensions dim(0, 0, 300, 500), newDim).toBe null

  describe "when panel opened right", ->

    it "expands to the right", ->
      calc = new FoldCalculator dim(0, 0, 300, 500), dim(200, 100, 300, 500)

      # panel 100 wide opened to the right
      windowDim = dim(200, 100, 300, 500)
      newDim = calc.calcDimensions dim(0, 0, 200, 500), windowDim
      expect(newDim).toEqual dim 200, 100, 400, 500

      # panel closed again
      newDim = calc.calcDimensions dim(0, 0, 400, 500), newDim
      expect(newDim).toEqual dim 200, 100, 300, 500

      # another calculation after resize won't change nothing
      expect(calc.calcDimensions dim(0, 0, 300, 500), newDim).toBe null

  describe "only window moved", ->

    it "it won't resize", ->
      calc = new FoldCalculator dim(0, 0, 300, 500), dim(200, 100, 300, 500)

      # window moved down and right
      windowDim = dim(250, 160, 300, 500)
      newDim = calc.calcDimensions dim(0, 0, 300, 500), windowDim
      expect(newDim).toBe null

  describe "window moved and panel opened right", ->

    it "expands to the right at new position", ->
      calc = new FoldCalculator dim(0, 0, 300, 500), dim(200, 100, 300, 500)

      # panel 100 wide opened to the right, window moved up and left
      newDim = calc.calcDimensions dim(0, 0, 200, 500), dim(150, 40, 300, 500)
      expect(newDim).toEqual dim(150, 40, 400, 500)

      # panel closed again and window moved
      newDim = calc.calcDimensions dim(0, 0, 400, 500), dim(220, 130, 400, 500)
      expect(newDim).toEqual dim(220, 130, 300, 500)

      # another calculation after resize won't change nothing
      expect(calc.calcDimensions dim(0, 0, 300, 500), newDim).toBe null

dim = (x, y, width, height) ->
  {x, y, width, height}
