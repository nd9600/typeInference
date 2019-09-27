Red [
    Title: "Types needed when assigning typenames"

]

Type: make Obj [
    _type: append self/_type "Type"
]

; used for literals like true | false | "abcdef" | 12 | 34.6 | %file.red | https://www.example.com
ConstantType: make Type [
    _type: append self/_type "ConstantType"

    datatype: none ; logic! | string! | file! | url! | char! | integer! | float!

    equalToOtherType: function [
        otherType [object!]
    ] [
        all [
            self/isType "ConstantType"
            otherType/datatype == otherType/datatype
        ]
    ]

    toString: does [
        mold self/datatype
    ]
]

; represents a symbolic type name like `t1` or `t2`
TypeVar: make Type [
    _type: append self/_type "TypeVar"

    name: none

    equalToOtherType: function [
        otherType [object!]
    ] [
        all [
            otherType/isType "TypeVar"
            self/name == otherType/name
        ]
    ]

    toString: does [
        self/name
    ]
]

; represents a function that has n arguments and always returns 1 thing
FunctionType: make Type [
    _type: append self/_type "FunctionType"

    ; a block! of Type's
    argTypes: copy []
    returnType: none

    equalToOtherType: function [
        otherType [object!]
    ] [
        if not all [
            otherType/isType "FunctionType"
            (length? self/argTypes) == (length? otherType/argTypes)
            otherType/returnType == self/returnType
        ] [
            return false
        ]
        repeat i (length? self/argTypes) [
            if (not self/argTypes/:i/equalToOtherType otherType/argTypes/:i) [
                return false
            ]
        ]
        true
    ]

    toString: does [
        either (length? self/argTypes) == 1 [
            rejoin ["(" self/argTypes/1/toString " -> " self/returnType/toString ")"]
        ] [
            argsAsString: (f_map lambda [?/toString] self/argTypes)
                |> lambda [join ? ", "]
            rejoin ["((" argsAsString ") -> " self/returnType/toString ")"]
        ]
    ]
]