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
]

; represents a function that has n arguments and always returns 1 thing
FunctionType: make Type [
    _type: append self/_type "FunctionType"

    ; a block! of Type's
    argTypes: copy []
    returnType: none
]

; represents a symbolic type name like `t1` or `t2`
TypeVar: make Type [
    _type: append self/_type "TypeVar"

    name: none 
]