Red [
    Title: "Nathan's AST typename assigner"
    Description: {
        Given an AST, walk it and assign each subexpression a type name: if the expression is a literal, use the actual constant type; if not, assign a unique symbolic type name. Returns annotated AST
    }
]

export typenameAssigner

typenameAssigner: context [
    annotatedAST: none

    assignTypenames: function [
        ast [object!]
        return: [object!] ;"the annotated AST, where each node has a 'type property"
    ] [
        self/annotatedAST: none
        self/annotatedAST
    ]
]
