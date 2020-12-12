; shows time in string using si pointer and 2ch function
stk segment stack 'stack'
    dw 32 dup(?)
stk ends

dts segment
    time db 10, 13, 'Time is now :  :  ', 10, 13, '$' ; 2 space before & after colon
dts ends

cds segment
    assume cs:cds, ss:stk, ds:dts
main proc far
    mov ax, seg dts
    mov ds, ax

    mov si, offset time + 15                          ; moves the pointer after first color
    mov ah,2ch                                        ; reads time
    int 21h

    mov al, ch                                        ; mov the hour into al
    xor ah, ah                                        ; mov ah,0
    mov bl, 10
    div bl                                            ; ax / bl | al=kharej az ghesmat , ah=baghimandeh
    add ax, 3030h                                     ; or ax,3030h
    mov [si], ax

    mov al, cl                                        ; moves the second into al
    xor ah, ah                                        ; mov ah,0
    div bl
    add ax, 3030h
    mov [si+3],ax

    mov ah,09h
    mov dx, offset time
    int 21h

    mov ah,4ch
    int 21h
main endp
cds ends
end main
