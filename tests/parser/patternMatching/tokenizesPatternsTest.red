Red [
    Title: "Tests for tokenizing pattern matching"
    Description: {
        Pattern matching looks like this
        ```
        l: [1 2 3 4]
        newL: match l [
            | [x _: xs] -> x * 2
            | [] -> []
        ]
        ; newL == [2 4 6 8]
        ```

        These tests check if the 2nd argument to 'match
        ```
        [
            | [x _: xs] -> x * 2
            | [] -> []
        ]
        ```
        is tokenized correctly
    }
]

do %lib/helpers.red
do %lib/obj.red
moduleLoader: context load %lib/moduleLoader.red

do %src/parser/tokens.red
parser: moduleLoader/import %src/parser/parser.red

tests: context [
    testTokenizesSimplePattern: does [
        simplePattern: [
            | [x _cons xs] -> x * 2
            | [] -> []
        ]

        tokens: parser/tokenize simplePattern

        expectedTokens: reduce [
            VerticalBar 
                BlockStart make WordToken [value: 'x] ListCons make WordToken [value: 'xs] BlockEnd
                Arrow
                make Code [value: [x * 2]]
            VerticalBar 
                BlockStart BlockEnd
                Arrow
                make Code [value: [[]]]
        ]

        actualTypes: f_map lambda [last ?/_type] tokens
        expectedTypes: f_map lambda [last ?/_type] expectedTokens

        assert [
            (actualTypes) == expectedTypes
            ; (tokens) == expectedTokens
        ]
    ]

    testTokenizesPatternsWithWildcard: does [
        patternWithWildcard: [
            | [x _cons xs] -> x * 2
            | _ -> []
        ]

        tokens: parser/tokenize patternWithWildcard

        expectedTokens: reduce [
            VerticalBar 
                BlockStart make WordToken [value: 'x] ListCons make WordToken [value: 'xs] BlockEnd
                Arrow
                make Code [value: [x * 2]]
            VerticalBar 
                Wildcard
                Arrow
                make Code [value: [[]]]
        ]

        actualTypes: f_map lambda [last ?/_type] tokens
        expectedTypes: f_map lambda [last ?/_type] expectedTokens

        assert [
            (actualTypes) == expectedTypes
            ; (tokens) == expectedTokens
        ]
    ]
]