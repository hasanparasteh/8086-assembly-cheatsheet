; show the values of flags: cf(no shift needed), zf(6 shift to right), sf(7 shift to right), of(11 shift to right)
stk segment stack 'stack'
    dw 32 dup(?)
stk ends

dts segment
    msg db 10, 13, 'CF=  '
        db 10, 13, 'ZF=  '
        db 10, 13, 'SF=  '
        db 10, 13, 'OF=  ', '$'
    zf db 6
    sf db 7
    of db 11
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts
main proc far
    mov ax, seg dts
    mov ds, ax
    mov es, ax

    mov si, offset msg + 6
    mov di, offset zf
    mov cl, 0
    mov ch, 4

    mov al, 80h
    neg al
    pushf
    pop ax
l1:
    mov bx,ax
    shr bx, cl
    and bx, 1 ; set all bits to zero except the zero location bit
    add bl, 30h
    mov byte ptr [si], bl

    add si, 7
    mov cl, byte ptr [di]
    inc di
    dec ch
    jne l1

    mov ah, 09h
    mov dx, offset msg
    int 21h

    mov ah,4ch
    int 21h
main endp
cds ends
end main
