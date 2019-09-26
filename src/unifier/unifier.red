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
    none   
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
        subst is none [
            none
        ]
        x == y [
            subst
        ]
        x is Var [
            unifyVariable x y subst
        ]
        y is Var [
            unifyVariable y x subst
        ]
        all [
            x is App
            y is App
        ] [
            either any [
                x.fname != y.fname
                (length? x/args) != (length? y/args)
            ] [
                none
            ] [
                repeat i (length? x/args) [
                    subst = unify x/args/i y/args/i subst
                ]
                subst
            ]
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
    assert v is Var
    case [
        v/name in subst [
            unify subst(v/name) x subst
        ]
        all [         ; this fixes the "common error" Peter Norvig describes in "Correcting a Widespread Error in Unification Algorithms"
            x is Var
            x/name in subst
        ] [
            unify v subst/(x/name) subst
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
    assert v is Var
    case [
        v == term [
            true
        ]
        all [         
            term is Var
            term/name in subst
        ] [
            occursCheck v subst/(term/name) subst
        ]
        term is App [
            foreach arg term/args [
                if occursCheck v arg subst [
                    return true
                ]
                return false
            ]
        ]
        true [
            false
        ]
    ]
]