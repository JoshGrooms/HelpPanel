
{ isempty } = require('./Extensions')()


module.exports = RXP =

    DocumentationAbove: (commentOpen, commentClose, word) ->
        docStartWord = word.toUpperCase()
        if isempty(commentClose)
            return ///
                    (
                        [^\n]* #{commentOpen} \s* \b#{docStartWord}\b .* \r?\n
                        (?: ^[^\n]* #{commentOpen} .* \r?\n )*
                    )
                    (?: (.(?!#{commentOpen}))* \b#{word}\b )
                  ///m
        else
            return ///
                    (
                        [^\n]* #{commentOpen} \s* \b#{docStartWord}\b (.*\n)*
                        .* #{commentClose} .*\n
                    )
                    (?: (.(?!#{commentOpen}))* \b#{word}\b )
                  ///m





    DocumentationBelow: (commentOpen, commentClose, word) ->
        docStartWord = word.toUpperCase()
        if isempty(commentClose)
            return ///
                    (?: (.(?!#{commentOpen}))* \b#{word}\b .* \r?\n )
                    (
                        [^\n]* #{commentOpen} \s* \b#{docStartWord}\b .* \r?\n
                        (?: ^[^\n]* #{commentOpen} .* \r?\n )*
                    )
                   ///m
        else
            return ///
                    (?: (.(?!#{commentOpen}))* \b#{word}\b .* \r?\n )
                    (
                        [^\n]* #{commentOpen} \s* \b#{docStartWord}\b (.* \r?\n)*
                        .* #{commentClose} \r?\n
                    )
                   ///m


    DocumentationStart: (commentOpen, word) ->
        docStartWord = word.toUpperCase()
        return ///
                ( ^[^\n]* (?: #{commentOpen} )* \s* )
                (?: \b#{docStartWord}\b )
              ///m
