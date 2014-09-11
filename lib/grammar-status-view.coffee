{View} = require 'atom'

# View to show the grammar name in the status bar.
module.exports =
class GrammarStatusView extends View
  @content: ->
    @div class: 'grammar-status', =>
      @a href: '#', class: 'inline-block'

  initialize: (@statusBar) ->
    @subscribe @statusBar, 'active-buffer-changed', =>
      @updateGrammarText()

    @subscribe atom.workspace.eachEditor (editor) =>
      @subscribe editor, 'grammar-changed', =>
        @updateGrammarText() if editor is atom.workspace.getActiveEditor()

    atom.config.observe 'grammar-selector.showOnRightSideOfStatusBar', =>
      @attach()

    @subscribe this, 'click', ->
      atom.workspaceView.trigger('grammar-selector:show')
      false

  attach: ->
    if atom.config.get 'grammar-selector.showOnRightSideOfStatusBar'
      @statusBar.prependRight(this)
    else
      @statusBar.appendLeft(this)

  afterAttach: ->
    @updateGrammarText()

  updateGrammarText: ->
    grammar = atom.workspace.getActiveEditor()?.getGrammar?()
    if grammar?
      if grammar is atom.syntax.nullGrammar
        grammarName = 'Plain Text'
      else
        grammarName = grammar.name ? grammar.scopeName
      @children()
        .text(grammarName)
        .attr('title', grammarName)
        .show()
    else
      @hide()
