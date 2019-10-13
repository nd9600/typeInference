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
            | [x _: xs] -> x * 2
            | [] -> []
        ]

        tokens: parser/tokenize simplePattern

        expectedTokens: reduce [
            VerticalBar 
                BlockStart Word ListCons Word BlockEnd
                Arrow
                Code
            VerticalBar 
                BlockStart BlockEnd
                Arrow
                Code
        ]

        assert [
            (tokens) == expectedTokens
        ]
    ]
]