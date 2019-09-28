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
    testSimpleUnification: does [
        typeConstraints: reduce [
            make TypeEquation [
                left: make FunctionType [
                    argTypes: reduce [
                        make ConstantType [datatype: string!]
                        make ConstantType [datatype: integer!]
                        make FunctionType [
                            argTypes: reduce [
                                make ConstantType [datatype: logic!]
                            ]
                            returnType: make ConstantType [datatype: integer!]
                        ]
                    ]
                    returnType: make ConstantType [datatype: float!]
                ]
                right: make FunctionType [
                    argTypes: reduce [
                        make ConstantType [datatype: string!]
                        make TypeVar [name: "V"]
                        make TypeVar [name: "X"]
                    ]
                    returnType: make ConstantType [datatype: float!]
                ]
            ]
        ]

        print typeConstraints/1/toString
        substitution: unifier/solveTypeConstraints typeConstraints

        V: select substitution "V"
        X: select substitution "X"
        print V/toString
        print X/toString

        integerConstantType: make ConstantType [datatype: integer!]
        boolToIntType: make FunctionType [
            argTypes: reduce [
                make ConstantType [datatype: logic!]
            ]
            returnType: make ConstantType [datatype: integer!]
        ]

        assert [
            V/equalToOtherType integerConstantType
            X/equalToOtherType boolToIntType
        ]
    ]
]