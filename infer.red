Red [
    Title: "Nathan's type inference in Red"
    Description: {
        Infers the types of expressions in Red code, currently uses the Hindley-Milner type system
        Stage 0 (not specifically part of type inference): parses code into an Abstract Syntax Tree (AST) of sub-expressions
        Stage 1: Given that AST, walk it and assign each subexpression a type name: if the expression is a literal, use the actual constant type; if not, assign a unique symbolic type name. Returns AST annotated with typenames
        Stage 2: Given that AST annotated with typenames, use Red's typing rules to make a list of type equations/constraints, like
            ```
            t1 :: (t2 -> t3)
            t2 :: integer!
            ```
        Returns a list of type equations
        Stage 3: Solve the list of type constraints using the unification algorithm. Returns the substitution, a map! of (variable name to type)
            https://wiki.nd9600.download/type_inference.html#unification
        Stage 4 (optional): Use the substitution to find the type of an expression
    }
    Link: https://wiki.nd9600.download/type_inference.html#hindley-milner_type_system
]

do %lib/helpers.red
moduleLoader: context load %lib/moduleLoader.red

typeInferer: context [
    infer: function [
        code [block!]
        return: [map!] ;"the substitution, mapping from variable name to type"
    ] [
        parser: moduleLoader/import %parser.red
        typenameAssigner: moduleLoader/import %typenameAssigner.red
        typeConstraintGenerator: moduleLoader/import %typeConstraintGenerator.red
        unifier: moduleLoader/import %unifier.red

        ast: parser/parseCode code
        annotatedAST: typenameAssigner/assignTypenames ast
        typeConstraints: typeConstraintGenerator/generateTypeConstrains annotatedAST
        substitution: unifier/solveTypeConstraints typeConstraints
        ?? substitution
    ]
]

code: []
typeInferer/infer code