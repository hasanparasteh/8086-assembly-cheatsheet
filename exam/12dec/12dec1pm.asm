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

stk segment stack 'stack'
    dw 32 dup(?)
stk ends

dts segment
    msg db "Please enter max 80 char : ", 10, 13, "$"
    max db 80
    len db ?
    buffer db 80 dup(?)
    space_buffer db 10, 13, "$"
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts

main proc far
    mov ax, seg dts
    mov ds, ax


    M9 msg
    M0A max   ; we should add $ manually after our string

    mov cx, 6 ; code daneshjoyi

spaces:
    M9 space_buffer
    dec cx

    cmp cx, 4
    je print
    cmp cx, 0
    jz ending

print:
    M9 buffer
    jmp spaces

ending:
    mov ah, 4ch
    int 21h

main endp
cds ends
end main