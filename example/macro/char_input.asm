inputC MACRO
    mov ah, 08h
    int 21h
ENDM ; al = input char