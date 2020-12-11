; program to display directly to video ram
stk segment
    dw 32 dup(?)
stk ends

dts segment
    mes1 db 'Please enter max 80 character text: $'
    max db 81
    len	db ?
    str1 db 80 dup (?)
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts
main proc far
    mov ax, seg dts
    mov ds,ax
    mov ax,0b800h ; Video RAM segment
    mov es,ax
    mov ah,09h    ; display mes1
    mov dx,offset mes1
    int 21h
    mov ah,0ah    ; input from keyboard string for display
    mov dx,offset max
    int 21h
    mov si,offset str1
    mov cl,len
    xor ch,ch     ; cx= no. of characters entered by user
    mov di,320    ; offset 3rd line
    mov ah,71h    ; character colour attribute
    cld
l1:
    lodsb
    stosw         ; sending character to VRAM
    loop l1
    mov ah,4ch
    int 21h
    ret
main endp
cds ends
end main