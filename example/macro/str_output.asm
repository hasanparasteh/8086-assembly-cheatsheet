printS MACRO msg, len
    mov al, '$'
    mov byte ptr[offset len+1], al
    
    mov dx, offset msg
    mov ah, 09h
    int 21h
ENDM