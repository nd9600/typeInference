Red [
    Title: "Unifier tests - applying a substitution to a type"
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
    testAppliesSubstitutionToType: does [
        substitution: to-map reduce [
            "W" make FunctionType [
                argTypes: reduce [
                    make TypeVar [name: "X"]
                ]
                returnType: make ConstantType [datatype: integer!]
            ]
            "X" make FunctionType [
            argTypes: reduce [
                make TypeVar [name: "Z"]
            ]
            returnType: make ConstantType [datatype: integer!]
        ]
            "Y" make ConstantType [datatype: float!]
            "Z" make ConstantType [datatype: float!]
        ]

        ; foreach k keys-of substitution [
        ;     print rejoin [k ": " substitution/:k/toString]
        ; ]

        unifier/substitution: substitution
        wInSubstitution: unifier/applySubstitution make TypeVar [name: "W"]

        assert [
            wInSubstitution/toString == "((float! -> integer!) -> integer!)"
        ]
    ]
]