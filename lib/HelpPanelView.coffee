module.exports = class HelpPanelView

    constructor: (serializedState) ->
        # Create root element
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

    isVisible: ->
        @ModalPanel.isVisible()

    Hide: ->
        @ModalPanel.hide()

    Show: ->
        @ModalPanel.show()

    toggle: ->
        if @ModalPanel.isVisible()
            @hide()
        else
            @show()
