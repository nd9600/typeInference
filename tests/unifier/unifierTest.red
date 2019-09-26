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
geany
unifier: moduleLoader/import %src/unifier/unifier.red

tests: context [
    testUnifier: function [] [
        typeConstraints: [

        ]
        substitution: unifier/solveTypeConstraints typeConstraints
        assert [
            true
        ]
    ]
]