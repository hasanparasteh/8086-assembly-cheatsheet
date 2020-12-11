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
    ; variables goes here...
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

# Intrupts

## Strings & Char

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

; code segment
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

; code segment
mov dx,offset max
mov ah, 0ah
int 21h
```

### Add dollar sign at end of string

We should use pointers to do this. Also the correct way is to use bx but there is a trick to do it.

```asm
mov al,'$'
mov byte ptr[len+1],al
```

## Files Manipulation

### Create a file

we should use `3ch` as the function to create files. we should define `cx` to determine what type of manipulation we want.

```asm
mov cx, 0 ; normal - no attributes.
mov cx, 1 ; read-only.
mov cx, 2 ; hidden.
mov cx, 4 ; system
mov cx, 7 ; hidden, system and read-only!
mov cx, 16 ; archive
```

There are some flags to determine file creation was ok or not: `CF clear if successful, AX = file handle. CF set on error AX = error code.`

Example:

```asm
dts segment
    filename db "data.txt", 0
    handle dw ?
dts ends

; code segment
mov ah,3ch
mov cx,0
mov dx, offset filename
int 21h

jc error
mov handle, ax
jmp ok

error:
    ; error goes here
ok:
    ; do stuff
```

### Open a file

we should use `AL` to determine access and sharing modes:

```asm
mov al, 0 ; read
mov al, 1 ; write
mov al, 2 ; read/write
```

note 1: file pointer is set to start of file.
note 2: file must exist.
Example:

```asm
mov al,2
mov dx, offset filename
mov ah, 3dh
int 21h

jc error
mov handle,ax
jmk ok

error:
    ; error goes here

ok:
    ; do stuff
```

### Write file when it's openned

It should goes into ok label of `3ch` or `3dh`.

```asm
dts segment
    filename db "data.txt", 0
    handle dw ?

    max db 80
    len db ?
    msg db 80 dup(?)
dts ends

dts ends
mov ah,40h
mov bx,handle
mov cx,80
mov dx,offset msg
int 21h
```

### Read from file when it's openned

```asm
mov ah,3fh
mov bx,handle
mov cx,80 ; number of bytes to read
int 21h

; it automatically move the data into dx
; so if you wanna print it just type the below codes
mov ah,9
int 21h
```

### Close a file

```asm
mov ah,3eh
mov bx, handle
int 21h
```
