stk segment stack 'stack'
    dw 32 dup(?)
stk	ends

dts segment
    fnam db 'fl.txt',0
    fhndl dw ?
    bf db 10 dup('$')
    p1 db 10, 13,'Bytes read from file:', 10, 13, '$'
dts ends

cds segment
    assume cs:cds,ss:stk,ds:dts
main proc far
    mov ax,seg dts
    mov ds,ax

    ; opens file
    mov ah, 3dh
    mov al, 0             ; read only
    mov dx, offset fnam
    int 21h

    mov fhndl, ax

    ; reads file
    mov ah, 3fh
    mov bx, fhndl
    mov dx, offset bf
    mov cx, 7             ; bytes count that we want to read from file
    int 21h

    ; show p1
    mov ah, 09
    mov dx, offset p1
    int 21h

    ; show bf
    ; mov ah, 09 	not required
    mov dx, offset bf
    int 21h

    ; close the file & program
    mov ah, 3eh
    mov dx, fhndl
    int 21h

    mov ah, 4ch
    int 21h

main endp
cds ends
end main