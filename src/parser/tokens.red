Red [
    Title: "Tokens needed when tokenizing code"
]

Token: make Obj [
    _type: append self/_type "Token"
    value: none
]

VerticalBar: make Token [
    _type: append self/_type "VerticalBar"
    value: "|"
]

; ##########
; patterns
; ##########

; ####################
; lists
; ####################

BlockStart: make Token [
    _type: append self/_type "BlockStart"
    value: "["
]
ListCons: make Token [
    _type: append self/_type "ListCons"
    value: "_:"
]
BlockEnd: make Token [
    _type: append self/_type "BlockEnd"
    value: "]"
]

; ####################
; general
; ####################

Word: make Token [
    _type: append self/_type "BlockEnd"
    value: "]"
]

; ##########
; patterns
; ##########

Arrow: make Token [
    _type: append self/_type "Arrow"
    value: "->"
]

; ##########
; expressions
; ##########

Code: make Token [
    _type: append self/_type "Code"
    value: none
]