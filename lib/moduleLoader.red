Red [
    Title: "Red Module loader"
    License: "MIT"
    Description: {
        Imports word!s from a block!, file! or string!, without polluting the global scope. word!s can be defined as functions of other, non-exported word!s
    }
    Usage: {
        There are 2 ways to use this: exporting a block! of word!s, or exporting a single! word:

        #1
        ```
        do %moduleLoader.red

        h: moduleLoader/import/only [
            a: 1 
            b: 2 
            c: b * 2 
            d: function [][c + 1] 
            export [d]
        ] [
            d
        ]
    
        assert [
            (h/d) == (2 * 2 + 1)
            none? in h 'c
        ]
        ```

        #2
        ```
        do %moduleLoader.red

        h: moduleLoader/import [
            o: context [
                block: []
                _append: function [e] [append self/block e]
            ] 
            export o
        ]
        assert [
            empty? h/block
        ]

        h/_append 1234
        assert [
            not empty? h/block
            (first h/block) == 1234
        ]
        ```
    }
]

import: function [
    "Imports word!s from a block!, file! or string!, without polluting the global scope. word!s can be defined as functions of other, non-exported word!s"
    input [block! file! string!] "the thing to import, like [b: 1 c: b + 10 d: [4 5 6] export [d c e] e: c * 12]"
    /only "only import some word!s"
        wordsToImport [block!] "the word!s to import, like [a b]"
] [
    inputAsBlock: case [
        block? input [
            input
        ]
        any [
            file? input 
            string? input
        ] [
            load input
        ]
    ]

    ; find variables to export, and remove "export block!" from the block
    exportingVariables: copy []

    ; find the single variable to export, and remove "export word!" from the block
    thingToExport: copy []

    isExportingSingleVariable: false
    parse inputAsBlock [
        copy toExport to 'export skip
        [
            copy exportingBlock block! (
                append exportingVariables first exportingBlock
            )
        |
            copy thingToExport word! (
                isExportingSingleVariable: true
                thingToExport: first thingToExport ; it's a block! for some reason, so we need to get the actual word! out of it
            )
        ]
        copy fromExportToEnd to end
    ]
    if any [
        not value? 'toExport
        none? toExport
        all [
            empty? exportingVariables
            none? thingToExport
        ]
    ] [
        print rejoin [
            "couldn't export anything from " newline 
            mold inputAsBlock
        ]
        quit
    ]

    blockWithoutExport: compose [(toExport) (fromExportToEnd)]
    blockAsObject: context blockWithoutExport

    return either isExportingSingleVariable [
        get in blockAsObject thingToExport
    ] [
        ; extract the variables from the current scope
        bitThatReturnsVariables: copy []
        
        finalVariablesToExport: either only [
            importAndExportIntersection: intersect exportingVariables wordsToImport
            
            if ((length? importAndExportIntersection) <> (length? wordsToImport)) [
                print rejoin [
                    "import and export lists are different: #" 
                    difference exportingVariables wordsToImport 
                    "# is in the import list but not the import list"
                ]
            ]
            importAndExportIntersection
        ] [
            exportingVariables
        ]
            
        foreach variableToExport finalVariablesToExport [
            variableToExportAsLitWord: to-lit-word :variableToExport

            either (not none? find blockAsObject variableToExportAsLitWord) [
                append bitThatReturnsVariables compose/only [
                    (to-set-word :variableToExport) get in blockAsObject (variableToExportAsLitWord)
                ]
            ] [
                print rejoin [variableToExportAsLitWord " isn't exported in the input " type? input "!"]
            ]
        ]
        context bitThatReturnsVariables
    ]
]
