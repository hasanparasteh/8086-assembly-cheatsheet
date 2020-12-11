; Program that gets a string input and make it lower case
dts segment
    p1 db 10,13,'please enter max 80 characters',10,13,'$'
    max db 80
    len db ?
    str1 db 80 dup(?)
dts ends

cds segment
    assume cs:cds, ds:dts
main proc far
    mov ax, seg dts
    mov ds,ax
    mov ax,0b800h
    mov es,ax
    mov ah,09h
    mov dx,offset p1
    int 21h
    mov ah,0ah
    mov dx,offset max
    int 21h
    mov si,offset str1
    sub byte ptr[si], 20h
    mov di,960
    cld
    mov cl,len
    xor ch,ch
    mov ah,80
l1:
    cmp byte ptr[si],32
    jnz l2
    xor byte ptr[si+1], 20h
l2:
    lodsb
    stosw
    loop l1
    mov ah,4ch
    int 21h
main endp
cds ends
end main
