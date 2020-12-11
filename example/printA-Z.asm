; Program to display character 'A' at 0b800:0000 with 80h col
stk	segment stack 'stack'
    dw 32 dup(?)
stk	ends
cds	segment
    assume cs:cds,ss:stk
main	proc far
    mov cx,26
    cld ; DF=0
    mov ax,0b800h
    mov es,ax
    mov di,0
    mov al,'A'
    mov ah,50h
l1:	stosw
    inc al
    inc ah
    loop l1

    mov ah,4ch
    int 21h
main endp
cds	ends
end main