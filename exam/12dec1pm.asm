 M0A MACRO x
    mov dx, offset x
    mov ah, 0ah
    int 21h
ENDM

M9 MACRO payam
    mov dx, offset payam
    mov ah, 09h
    int 21h
ENDM

stk segment
    dw 32 dup(?)
stk ends

dts segment
    msg db 'Please enter max 80 char : ', 10, 13, '$'
    max db 80
    len db ?
    buffer db 80 dup("$")
    free db 10, 13
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts

main proc far
    mov ax, seg dts
    mov ds, ax

    M9 msg
    M0A max

    mov bl, 6 ; masalan akhar shomare daneshjoyi 6 hast
l1:
    cmp bl, 2
    je l2
    M9 free
    sub bl, 1
    cmp bl, 0
    jne l1
l2:
    M9 buffer
    ret


    mov ah, 4ch
    int 21h
main endp
cds ends
end main