Red [
    Title: "Base object"
]

Obj: context [
    _type: copy ["Obj"] ; append self/_type "NewType"
	isType: function [
        type [string!]
    ] [
        not none? find self/_type type
    ]
]