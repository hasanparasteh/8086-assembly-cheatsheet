extrn itoa:far
stk	segment
    dw 100h dup(?)
stk	ends
dts	segment
    flada db 178
    adadascii db 3 dup(' '),'$'
dts	ends
cds	segment
    assume cs:cds,ss:stk
main proc far
    mov ax,seg dts
    mov ds,ax
    mov si,offset adadascii
    mov al,flada
    xor ah,ah
    push ax
    call itoa
    mov ah,09
    mov dx,offset adadascii
    int 21h
    mov ah,4ch
    int 21h
main endp
cds	ends
end main