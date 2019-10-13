Red [
    Title: "Nathan's code -> AST parser"
    Description: "Parses code into an Abstract Syntax Tree (AST) of sub-expressions"
]

export parser

parser: context [
    ast: none

    parseCode: function [
        code [block!]
        return: [object!] ;"the AST"
    ] [
        self/ast: none
        self/ast
    ]

    tokenize: function [
        "tokenizes a block! of code into a flat block! of tokens"
        codeBlock [block!]
        return [block!] ;"a flat list of Tokens"
    ] [
        tokens: copy []

        appendToken: func [
            tokenToAppend [object!]
        ] [
            append tokens tokenToAppend
        ]

        ; ##########
        ; PARSE rules
        ; ##########

        blockPatterns: [
            some [
                    '_cons (appendToken ListCons)
                |
                    set w word! (appendToken make WordToken [value: w])
            ]
        ]
        
        pattern: [
            '| (appendToken VerticalBar)
            [
                    set b block! (
                        appendToken BlockStart
                        if not empty? b [parse b blockPatterns]
                        appendToken BlockEnd
                    )
                |
                    '_ (appendToken Wildcard)
            ]
            '-> (appendToken Arrow)
            copy data to ['| | end] (appendToken make Code [value: data])
        ]

        rules: [
            some [
                pattern
            ]
        ]

        parse codeBlock rules
        ; prettyPrint f_map lambda [last ?/_type] tokens
        ; prettyPrint f_map lambda [?/value] tokens
        ; quit

        tokens
    ]
]