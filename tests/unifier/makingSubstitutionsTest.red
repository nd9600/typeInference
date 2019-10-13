Red [
    Title: "Unifier tests - making the substitutions"
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
        integerConstantType: make ConstantType [datatype: integer!]
        boolToIntType: make FunctionType [
            argTypes: reduce [
                make ConstantType [datatype: logic!]
            ]
            returnType: make ConstantType [datatype: integer!]
        ]
        floatConstantType: make ConstantType [datatype: float!]

        typeConstraints: reduce [
            make TypeEquation [
                left: make FunctionType [
                    argTypes: reduce [
                        make ConstantType [datatype: string!]
                        integerConstantType
                        boolToIntType
                    ]
                    returnType: make TypeVar [name: "Y"]
                ]
                right: make FunctionType [
                    argTypes: reduce [
                        make ConstantType [datatype: string!]
                        make TypeVar [name: "V"]
                        make TypeVar [name: "X"]
                    ]
                    returnType: floatConstantType
                ]
            ]
        ]

        substitution: unifier/solveTypeConstraints typeConstraints
        Y: select substitution "Y"
        V: select substitution "V"
        X: select substitution "X"

        assert [
            Y/equalToOtherType floatConstantType
            V/equalToOtherType integerConstantType
            X/equalToOtherType boolToIntType
        ]
    ]

    testUnificationFailsWithConflictingDefinitions: does [
        typeConstraints: reduce [
            make TypeEquation [
                left: make FunctionType [
                    argTypes: reduce [
                        make TypeVar [name: "X"]
                        make TypeVar [name: "Y"]
                        make TypeVar [name: "X"]
                    ]
                    returnType: make ConstantType [datatype: string!]
                ]
                right: make FunctionType [
                    argTypes: reduce [
                        make ConstantType [datatype: integer!]
                        make FunctionType [
                            argTypes: reduce [
                                make TypeVar [name: "X"]
                            ]
                            returnType: make ConstantType [datatype: string!]
                        ]
                        make ConstantType [datatype: string!]
                    ]
                    returnType: make ConstantType [datatype: string!]
                ]
            ]
        ]

        substitution: unifier/solveTypeConstraints typeConstraints
        assert [
            not found? substitution
        ]
    ]

    testComplicatedUnification: does [
        typeConstraints: reduce [
            make TypeEquation [
                left: make FunctionType [
                    argTypes: reduce [
                        make TypeVar [name: "X"]
                        make FunctionType [
                            argTypes: reduce [
                                make TypeVar [name: "X"]
                            ]
                            returnType: make ConstantType [datatype: integer!]
                        ]
                        make TypeVar [name: "Y"]
                        make FunctionType [
                            argTypes: reduce [
                                make TypeVar [name: "Y"]
                            ]
                            returnType: make ConstantType [datatype: integer!]
                        ]
                    ]
                    returnType: make TypeVar [name: "Y"]
                ]
                right: make FunctionType [
                    argTypes: reduce [
                        make FunctionType [
                            argTypes: reduce [
                                make TypeVar [name: "Z"]
                            ]
                            returnType: make ConstantType [datatype: integer!]
                        ]
                        make TypeVar [name: "W"]
                        make TypeVar [name: "Z"]
                        make TypeVar [name: "X"]
                    ]
                    returnType: floatConstantType
                ]
            ]
        ]

        substitution: unifier/solveTypeConstraints typeConstraints
        Y: select substitution "Y"
        X: select substitution "X"
        W: select substitution "W"
        Z: select substitution "Z"

        ; left
        ; ((X,              (X -> integer!), Y, (Y -> integer!)) -> Y)

        ; right
        ; (((Z -> integer!), W,              Z, X)               -> float!)

        ; so
        ; X :: (Z -> integer!) or  (Y -> integer!)
        ; W :: (X -> integer!)
        ; Y :: Z or float

        assert [
            W/equalToOtherType make FunctionType [
                argTypes: reduce [
                    make TypeVar [name: "X"]
                ]
                returnType: make ConstantType [datatype: integer!]
            ]
            X/equalToOtherType make FunctionType [
                argTypes: reduce [
                    make TypeVar [name: "Z"]
                ]
                returnType: make ConstantType [datatype: integer!]
            ]
            Y/equalToOtherType make ConstantType [datatype: float!]
            Z/equalToOtherType make ConstantType [datatype: float!]
        ]
    ]
]