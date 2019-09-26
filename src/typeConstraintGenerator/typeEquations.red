Red [
    Title: "Type equations the type constrain generator makes"
    Description: {
        A type equation/constraint says the left-hand side is equal to the RHS, like
        ```
            t1 = (t2 -> t3)
            t2 = integer!
            logic! = logic!
        ```
        LHS and RHS are instances of %typenameAssigner/types.red
        The LHS is normally a symbolic type name, like `t1` or `t2`, but can also be a ConstantType
        The RHS can either be 
            one of Red's normal types (see `? datatype!`), which will be a ConstantType
            a function, with a list of argtypes
            a symbolic type name
    }
]

TypeEquation: make obj [
    _type: append self/_type "TypeEquation"

    left: none
    right: none

    originalNode: none ; for debugging purposes
]