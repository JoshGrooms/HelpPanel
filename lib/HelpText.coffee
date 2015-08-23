# HELPTEXT -

# CHANGELOG
# Written by Josh Grooms on 20150821

RXP = require './RXP'
{ isempty } = require('./Extensions')()


module.exports = class HelpText
    _CommentOpen:           null
    _CommentCharacters:     null
    _CommentClose:          null
    _RawText:               null

    Editor:                 null
    Text:                   null

    Summary:                null
    Syntax:                 null
    Input:                  null
    Output:                 null
    SeeAlso:                null

    Word:                   null

    ### CONSTRUCTOR & DESTRUCTOR METHODS ###
    constructor: (@Editor, @Word) ->
        @_CommentCharacters = @GetCommentCharacters()
        @_RawText = @Editor.GetAllText()
        @Text = @_RawText.replace(/\r\n/gm, '\n')
        @FindDocumentation()

        if isempty(@Text)
            @Text = "No documentation found for '#{@Word}'"
        else
            @FormatDocumentation()


    Search: (pattern) ->
        return @_RawText.match(pattern)



    EscapeCommentCharacters: (chars) ->
        s = ''
        for c in chars
            switch c
                when '$', '^', '*', '(', ')', '{', '}', '[', ']', '\\', '/', '.', '#', '%'
                    s = s.concat('\\', c)
                else s = s.concat(c)
        return s

    # FINDDOCUMENTATION - Finds any documentation comments associated with a specific word.
    #
    #   This method attempts to find a string of documentation comments adjacent to a particular word or query within the set
    #   of open text editors. The search query is controlled by whatever string is present in the 'Word' object property when
    #   this method gets called and any results of the search are placed in the 'Text' property. If documentation for a
    #   search word cannot be found, then the 'Text' property will take on a value of null. Otherwise, it will reference the
    #   first documentation string that is identified.
    #
    #   SYNTAX:
    #       @FindDocumentation()
    FindDocumentation: ->
        @_CommentCharacters = @GetCommentCharacters()

        @FindDocumentationAbove()
        if isempty(@Text)
            @FindDocumentationBelow()


    GetCommentCharacters: ->
        scopeDesc = @Editor.ActiveEditor.getRootScopeDescriptor()
        commentObjects = atom.config.getAll('editor.commentStart', scope: scopeDesc)
        commentObjects.push(atom.config.getAll('editor.commentEnd', scope: scopeDesc)[0])

        comments = [];
        for object in commentObjects
            comment = @EscapeCommentCharacters(object.value.trim())
            comments.push(comment)
        return comments



    FindDocumentationAbove: ->
        comments = @_CommentCharacters

        # Look for documentation made with inline comments first
        if (!isempty(comments[0]))
            rxp = RXP.DocumentationAbove(comments[0], '', @Word)
            @Text = @Search(rxp)
            @_CommentOpen = comments[0]
            @_CommentClose = null

        # If the above failed, look for documentation made with block comments instead
        if isempty(@Text)
            rxp = RXP.DocumentationAbove(comments[1], comments[2], @Word)
            @Text = @Search(rxp)
            @_CommentOpen = comments[1]
            @_CommentClose = comments[2]

        if (@Text isnt null) && (@Text.length >= 2)
            @Text = @Text[1]


    FindDocumentationBelow: ->
        comments = @_CommentCharacters

        # Look for documentation made with inline comments first
        if (!isempty(comments[0]))
            rxp = RXP.DocumentationBelow(comments[0], '', @Word)
            @Text = @Search(rxp)
            @_CommentOpen = comments[0]
            @_CommentClose = null

        # If the above failed, look for documentation made with block comments instead
        if isempty(@Text)
            rxp = RXP.DocumentationBelow(comments[1], comments[2], @Word)
            @Text = @Search(rxp)
            @_CommentOpen = comments[1]
            @_CommentClose = comments[2]

        if (@Text isnt null) && (@Text.length >= 3)
            @Text = @Text[2]


    FormatDocumentation: ->
        @Text = @Text.replace(/\r/gm, '')

        rxp = RXP.DocumentationStart(@_CommentOpen, @Word)
        docStart = @Text.match(rxp)[1]
        rxp = /// ^.{ 1, #{docStart.length} } ///gm
        @Text = @Text.replace(rxp, '')
