stk segment stack 'stack'
    dw 32 dup(?)
stk	ends

dts segment
    fnam db 'x.txt',0
    fhndl dw ?
    p1 db 10,13, '***** file Creation Ok ****',10,13,'$'
    p2 db 10,13, '***** Error ****',10,13,'$'
    p3 db 'Hello World!'
dts ends

cds segment
    assume cs:cds,ss:stk,ds:dts
main proc far
    mov ax,seg dts
    mov ds,ax
    mov ah,3ch
    mov cx,0
    mov dx, offset fnam
    int 21h
    jnc ok
    mov ah,09
    mov dx,offset p2
    int 21h
    jmp payan
ok:
    mov fhndl,ax
    mov ah,09
    mov dx,offset p1
    int 21h

    mov ah, 40h
    mov bx, fhndl
    mov cx, 12
    mov dx, offset p3
    int 21h

    mov ah,3eh
    mov bx,fhndl
    int 21h

payan:
    mov ah,4ch
    int 21h

main endp
cds ends
end main