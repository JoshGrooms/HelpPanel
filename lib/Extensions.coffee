

module.exports = ->

    isempty: (x) ->
        # ISEMPTY - Determines whether or not a variable is null or empty.
        return (x is null) || (x.length == 0)
