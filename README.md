# Assembly Cheatsheet

It's a great cheat sheet to helps you remember stuff in 8086 assembly programming.

## Basic Structure

Each assembly program should start with this style below:

```asm
stk segment stack 'stack'
    dw 32 dup(?)
stk ends
```

After that we have to define data segment:

```asm
dts segment
    " variables goes here...
dts ends
```

We need to define main function and code segment after that:

```asm
cds segment
    assume cs:cds, ss:stk, ds:dts
main proc far
    mov ax, seg dts
    mov ds,ax
```

Then we will write the functionality of code. After that you wrote the functionality or the codes you want, you have to end the program like this:

```asm
main endp
cds ends
end main
```

## Intrupts

### End Program

DOS interrupt int 21/4Ch is EXIT - TERMINATE WITH RETURN CODE, the content of al is used as the return code and the process is terminated.

```asm
mov ah,4ch
int 21h
```

### Write a char

Write character to standard output. entry: DL = character to write, after execution AL = DL.

```asm
mov ah,2
mov dl,'a'
int 21h
```

### Char input withou echo

Character input without echo to AL. if there is no character in the keyboard buffer, the function waits until any key is pressed.

```asm
mov ah,7
int 21h
```

### Write a string

Output of a string at DS:DX. String must be terminated by '$'.

```asm
dts segment
    msg db "hello world$"
dts ends

" code segment
mov dx, offset msg
mov ah,9
int 21h
```

### String input

Input of a string to DS:DX, fist byte is buffer size, second byte is number of chars actually read. this function does not add '$' in the end of string.

```asm
dts segment
    buffer db 80 dup(?)
    max db 80
    len db ?
dts ends

" code segment
mov dx,offset max
mov ah, 0ah
int 21h
```
