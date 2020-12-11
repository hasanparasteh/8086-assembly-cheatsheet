printC MACRO char
    mov dl, char
    mov ah, 02h
    int 21h
ENDM