commandDisposable = null
grammarListView = null
grammarStatusView = null

module.exports =
  config:
    showOnRightSideOfStatusBar:
      type: 'boolean'
      default: true
      description: 'Show the active pane item\'s langauge on the right side of Atom\'s status bar, instead of the left.'

  activate: ->
    commandDisposable = atom.commands.add('atom-text-editor', 'grammar-selector:show', createGrammarListView)

  deactivate: ->
    commandDisposable?.dispose()
    commandDisposable = null

    grammarStatusView?.destroy()
    grammarStatusView = null

    grammarListView?.destroy()
    grammarListView = null

  consumeStatusBar: (statusBar) ->
    GrammarStatusView = require './grammar-status-view'
    grammarStatusView = new GrammarStatusView().initialize(statusBar)
    grammarStatusView.attach()

createGrammarListView = ->
  unless grammarListView?
    GrammarListView = require './grammar-list-view'
    grammarListView = new GrammarListView()
  grammarListView.toggle()
