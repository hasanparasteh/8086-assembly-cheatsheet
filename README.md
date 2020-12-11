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
