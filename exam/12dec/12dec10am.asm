; use graphic processor to print your name on line of the last number of student code
stk segment stack 'stack'
    dw 32 dup(?)
stk ends

dts segment
    msg db 'Hasan Parasteh'
    msg_size db 14
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts
main proc far
    mov ax, seg dts
    mov ds,ax
    mov ax,0b800h
    mov es,ax
    mov si,offset msg
    mov di,1440 ; 9th line | line is like: 0: 0, 1:160, 2:320, 3:480, ...
    mov cx, offset msg_size
    mov ah,80h
    cld
l1:
    lodsb
    stosw
    loop l1

    mov ah,4ch
    int 21h
main endp
cds ends
end main