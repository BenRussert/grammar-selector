{View} = require 'atom'

# View to show the grammar name in the status bar.
module.exports =
class GrammarStatusView extends View
  @content: ->
    @a href: '#', class: 'grammar-name inline-block'

  initialize: (@statusBar) ->
    @subscribe @statusBar, 'active-buffer-changed', @updateGrammarText

    @subscribe this, 'click', =>
      atom.workspaceView.getActiveView().trigger('grammar-selector:show')
      false

    @subscribe atom.workspaceView, 'editor:grammar-changed', @updateGrammarText

  afterAttach: ->
    @updateGrammarText()

  updateGrammarText: =>
    grammar = atom.workspaceView.getActivePaneItem()?.getGrammar?()
    if grammar?
      if grammar is atom.syntax.nullGrammar
        grammarName = 'Plain Text'
      else
        grammarName = grammar.name
      @text(grammarName).show()
    else
      @hide()
