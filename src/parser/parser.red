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
        code [block!]
        return [block!] ;"a flat list of Tokens"
    ] [
        none
    ]
]