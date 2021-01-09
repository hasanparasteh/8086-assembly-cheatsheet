stk segment stack 'stack'
    dw 32 dup(?)
stk ends
cds segment
    assume cs:cds, ss:stk
main proc far
    mov al, 12h
    mov ah, 0
    int 10h                          ; set graphics video mode.
                                     ; Show a pixel in center with blue color

    mov ah, 0Ch
    mov al, 12                       ; Color
    mov bh, 0                        ; Page Number
    mov dx, 100                      ; Y Position
    mov cx, 160                      ; X Position
line:
    int 10h
    inc dx
    inc cx

    cmp dx, 200
    jne line

    mov ah, 01                       ; switch in text mode
    int 21h

    mov ah, 4ch
    int 21h

main endp
cds ends
end main