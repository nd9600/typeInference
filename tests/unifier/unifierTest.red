Red [
    Title: "Unifier tests"
    Description: {
        Solve the list of type constraints using the unification algorithm. Returns the substitution, a map! of (variable name to type)
            https://wiki.nd9600.download/type_inference.html#unification
        Type constrains are like
        ```
            t1 :: (t2 -> t3)
            t2 :: integer!
        ```
    }
]

do %lib/helpers.red
do %lib/obj.red
moduleLoader: context load %lib/moduleLoader.red

do %src/typenameAssigner/types.red
do %src/typeConstraintGenerator/typeEquations.red
unifier: moduleLoader/import %src/unifier/unifier.red

tests: context [
    testUnifier: does [
        typeConstraints: reduce [
            make TypeEquation [
                left: make TypeVar [name: "t1"]
                right: make FunctionType [
                    argTypes: [
                        make TypeVar [name: "t2"]
                    ]
                    returnType: make TypeVar [name: "t3"]
                ]
            ]

            make TypeEquation [
                left: make TypeVar [name: "t2"]
                right: make ConstantType [datatype: integer!]
            ]
        ]
        probe typeConstraints/1/right/toString
        substitution: unifier/solveTypeConstraints typeConstraints
        assert [
            true
        ]
    ]
]