Red [
    Title: "Nathan's type constrain unifier"
    Description: {
        Solve a list of type constraints using the unification algorithm. Returns the substitution, a map! of (variable name to type)
    }
    Link: https://wiki.nd9600.download/type_inference.html#unification
]

export [solveTypeConstraints]

solveTypeConstraints: function [
    "solves a list of type constraints, finding the most general unifier"
    typeConstraints [block!] "the list of type constraints"
    return: [map!] ;"the substitution, mapping from variable name to type"
] [
    substitution: make map! []
    foreach constraint typeConstraints [
        substitution: unify constraint/left constraint/right substitution
    ]
    substitution
]

unify: function [
    {Unifies term 'x and 'y with initial 'subst.

Returns a substitution (a map of name -> term) that unifies 'x and 'y, or none if they can't be unified. Pass 'subst = {} if no substitution is initially known. Note that {} means a valid (but empty) substitution
    }
    x       [object!] "term"
    y       [object!] "term"
    subst   [map! none!]
    return: [map! none!]
] [
    case [
        not found? subst [
            none
        ]
        x/equalToOtherType y [
            subst
        ]
        x/isType "TypeVar" [
            unifyVariable x y subst
        ]
        y/isType "TypeVar" [
            unifyVariable y x subst
        ]
        all [
            x/isType "FunctionType"
            y/isType "FunctionType"
        ] [
            if (length? x/argTypes) <> (length? y/argTypes) [
                return none
            ]
            subst: unify x/returnType y/returnType subst
            repeat i (length? x/argTypes) [
                subst: unify x/argTypes/:i y/argTypes/:i subst
            ]
            subst
        ]
        true [
            none
        ]
    ]
]

unifyVariable: function [
    "Unifies variable 'v with term 'x, using 'subst. Returns updated 'subst or none on failure"
    v     [object!] "variable"
    x     [object!] "term"
    subst [map!]
    return: [map! none!]
] [
    assert [
        v/isType "TypeVar"
    ]

    case [
        found? select subst v/name [
            unify subst(v/name) x subst
        ]
        all [         ; this fixes the "common error" Peter Norvig describes in "Correcting a Widespread Error in Unification Algorithms"
            x/isType "TypeVar"
            found? xInTheSubstitution: select subst x/name
        ] [
            unify v xInTheSubstitution subst
        ]
        occursCheck v x subst [
            none
        ]
        true [
            ; v is not yet in subst and can't simplify x, returns a new map like 'subst but with the key v.name = x
            put subst v/name x
            subst
        ]
    ]
]

occursCheck: function [
    {Does the variable 'v occur anywhere inside 'term?

Needed to guarantee that there aren't any variable bindings that refer to themselves, like X = f(X), which might cause infinite loops

Variables in 'term are looked up in subst and the check is applied recursively}
    v     [object!] "variable"
    term  [object!] "term"
    subst [map!]
    return: [logic!]
] [
    assert [
        v/isType "TypeVar"
    ]
    case [
        v/equalToOtherType term [
            true
        ]
        all [         
            term/isType "TypeVar"
            found? termIsInTheSubstitution: select subst term/name
        ] [
            occursCheck v termIsInTheSubstitution subst
        ]
        term/isType "FunctionType" [
            foreach arg term/argTypes [
                if occursCheck v arg subst [
                    return true
                ]
            ]
            return false
        ]
        true [
            false
        ]
    ]
]