Red [
    Title: "Base object"
]

Obj: context [
    type: copy ["Obj"] ; append self/type "NewType"
	isType: function [
        type [string!]
    ] [
        not none? find self/type type
    ]
]