inputS MACRO max
    mov dx, offset max
    mov ah, 0ah
    int 21h
ENDM