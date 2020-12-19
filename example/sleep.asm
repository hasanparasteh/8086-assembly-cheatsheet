; print each char after 5 second sleep
stk segment stack 'stack'
    dw 32 dup(?)
stk ends

dts segment
    msg db 'abc'
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts
main proc far
    mov ax, seg dts
    mov ds, ax

    mov si, offset msg
    mov bh, 3  ; use as counter for amount of char in our str
print:
    mov ah,02  ; shows a char
    mov dl, byte ptr[si]
    int 21h
    inc si     ; goes for next char
    dec bh     ; decrement the counter

    mov ah,2ch ; reads time
    int 21h

    mov bl, dh ; mov the second into bl
    add bl, 5  ; seconds to sleep
    cmp bl, 59
    jng sleep
    sub bl, 59
sleep:
    int 21h
    cmp bl,dh
    jne sleep
    cmp bh,0
    jne print

    mov ah,4ch
    int 21h
main endp
cds ends
end main
