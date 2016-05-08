# build time tests for popup plugin
# see http://mochajs.org/

popup = require '../client/popup'
expect = require 'expect.js'

describe 'popup plugin', ->

  describe 'expand', ->

    it 'can make itallic', ->
      result = popup.expand 'hello *world*'
      expect(result).to.be 'hello <i>world</i>'
