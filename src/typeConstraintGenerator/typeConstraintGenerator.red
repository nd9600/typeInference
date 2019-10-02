Red [
    Title: "Nathan's code -> AST parser"
    Description: {
        Given an AST annotated with type names, use Red's typing rules to make a list of type equations/constraints, like
            ```
            t1 :: (t2 -> t3)
            t2 :: integer!
            ```
        Returns a list of type equations
    }
]

export typeConstraintGenerator

typeConstraintGenerator: context [
    typeConstraints: none

    generateTypeConstrains: function [
        "makes a list of type contraints from an annotated AST"
        ast [object!] "the AST annotated with typenames"
        return: [block!] ;"the list of type equations"
    ] [
        self/typeConstraints: none
        self/typeConstraints
    ]
]