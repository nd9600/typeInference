Red [
    Title: "Base object"
]

; o: make Obj [_type: append self/_type "NewType"]
Obj: context [
    _type: copy ["Obj"]
	isType: function [
        typeString [string!]
    ] [
        not none? find self/_type typeString
    ]
]