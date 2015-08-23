# CHANGELOG
# Written by Josh Grooms on 20150820

{ CompositeDisposable } = require 'atom'
Editor                  = require './Editor'
HelpPanelView           = require './HelpPanelView'
HelpText                = require './HelpText'
{ isempty }             = require('./Extensions')()



# HELPPANEL -
module.exports = HelpPanel =
    Subscriptions:      null
    UI:                 null


    activate: (state) ->
        @Editor = new Editor()
        @Subscriptions = new CompositeDisposable
        @UI = new HelpPanelView(state.HelpViewState)

        # Register command that toggles this view
        @Subscriptions.add(atom.commands.add('atom-workspace', 'HelpPanel:toggle': => @Toggle()))

    deactivate: ->
        @Editor.destroy()
        @Subscriptions.dispose()
        @UI.destroy()

    serialize: ->
        HelpViewState: @UI.serialize()

    # TOGGLE - Toggles the visibility of the help pane on or off.
    #
    #   This function serves as the callback when the keyboard shortcut for the Help Panel package is invoked. It sets the
    #   panel containing documentation text to either visible or invisible, depending on the panel's previous state.
    #
    #   SYNTAX:
    #       @Toggle()
    Toggle: ->
        if @UI.isVisible()
            @UI.Hide()
        else
            word = @Editor.GetSelection()
            if (word.length == 0) then word = @Editor.SelectNearbyWord()
            help = new HelpText(@Editor, word)

            @UI.SetText(help.Text)
            @UI.Show()

    # SELECTWORD - Selects the complete word surrounding or immediately adjacent to the active editor cursor position.
    #
    #   SYNTAX:
    #       w = @SelectWord()
    #
    #   OUTPUT:
    #       w:      STRING
    #               Any complete word that is immediately adjacent to the current cursor position or surrounds it. Words are
    #               found using regular expression '\w' characters, which include alphanumeric and underscore characters, and
    #               extend left and right relative to the cursor until a non-word character is found (such as a '.' or '\s').
    SelectWord: ->
        word = @Editor.GetSelection()
        if (word.length == 0)
            word = @Editor.SelectWord()
        return word
