stk segment stack 'stack'
    dw 32 dup(?)
stk ends
cds segment
    assume cs:cds, ss:stk
main proc far
    mov al, 13h
    mov ah, 0
    int 10h               ; set graphics video mode.

                          ; Show a pixel in center with blue color
    mov ah, 0Ch
    mov al, 1             ; Color Blue
    mov bh, 0             ; Page Number
    mov dx, 100           ; Y Position
    mov cx, 160           ; X Position
    int 10h

    mov ah, 4ch
    int 21h

main endp
cds ends
end main