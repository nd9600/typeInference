Red [
    Title: "Nathan's type constrain unifier"
    Description: {
        Solve a list of type constraints using the unification algorithm. Returns the substitution, a map! of (variable name to type)
    }
    Link: https://wiki.nd9600.download/type_inference.html#unification
]

export [unify]

unify: function [
    "solves a list of type constraints, finding the most general unifier"
    typeConstraints [object!] "the list of type constraints"
    return: [map!] ;"the substitution, mapping from variable name to type"
] [
    none   
]