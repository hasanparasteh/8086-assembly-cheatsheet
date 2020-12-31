prcs segment
    assume cs:prcs
itoa proc far
    mov bp,sp
    mov ax,[bp+4]
    mov bl,10
    div bl
    or ah,30h ; add ah,30h
    mov byte ptr [si+3],ah
    xor ah,ah
    div bl
    or ax,3030h
    mov [si],ax
    ret
itoa endp
prcs ends
end main