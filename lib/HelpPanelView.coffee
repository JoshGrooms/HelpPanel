module.exports = class HelpPanelView

    constructor: (serializedState) ->
        @HelpPanel = document.createElement('div')
        @HelpPanel.classList.add('HelpPanel', 'inset-panel', 'padded')
        @ModalPanel = atom.workspace.addModalPanel(item: @HelpPanel, visible: false)



    # SERIALIZE - Returns an object that can be retrieved when package is activated
    serialize: ->

      # Tear down any state and detach
    destroy: ->
        @HelpPanel.remove()
        @ModalPanel.destroy()

    getElement: ->
        @HelpPanel

    # SETTEXT - Sets the block of text that is displayed in the help panel.
    #
    #   SYNTAX:
    #       @SetText(text)
    #
    #   INPUT:
    #       text:       STRING
    #                   The string of text to be displayed inside of the help panel. Formatting within the string is
    #                   preserved when displayed.
    SetText: (text) ->
        @HelpPanel.textContent = text

    IsVisible: ->
        return @ModalPanel.isVisible()

    # HIDE - Hides the help panel user interface.
    Hide: ->
        @ModalPanel.hide()

    # SHOW - Shows the help panel user interface.
    Show: ->
        @ModalPanel.show()

    toggle: ->
        if @ModalPanel.isVisible()
            @hide()
        else
            @show()
