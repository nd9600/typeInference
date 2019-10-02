Red [
    Title: "Nathan's .env loader"
    Author: "Nathan"
    License: "MIT"
    Description: {
        Loads variables from a file/string into the environment
        The format *must* be KEY="VALUE", but there can be blank lines anywhere in the file
        Usage:
        ```
        dotenv: context load %dotenv.red
        dotenv/loadEnv
        ```
    }
]

loadEnv: function [
    {loads variables from a file into the environment, the format *must* be KEY="VALUE"}
    /env "load something other than %.env"
        envSource [file! string!]
] [
    envContent: either envSource [
        switch type?/word envSource [
            file! [
                read envSource
            ]
            string! [
                envSource
            ]
        ]
    ] [
        read %.env
    ]

    lines: (split envContent newline)
        |> [f_map lambda [trim ?]]
        |> [f_filter lambda [not empty? ?]]

    foreach line lines [
        lineCopy: copy line
        numberOfEquals: 0
        while [lineCopy: find/tail lineCopy "="] [
            ; we need to allow KEY="A\=VALUE"
            charBeforeMatch: first back back lineCopy
            if (charBeforeMatch <> #"\") [
                numberOfEquals: numberOfEquals + 1
            ]
        ]
        if (numberOfEquals <> 1) [
            continue
        ]

        ; we're requiring the values to be surrounded by double quotes
        parse line [
            copy key to "=" "=" {"}
            copy value to [{"} end]
        ]
        if any [
            not found? key
            not found? value
        ] [
            continue;
        ]
        set-env key value
    ]
]