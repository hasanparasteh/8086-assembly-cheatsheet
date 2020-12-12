# Assembly Cheatsheet

It's a great cheat sheet to helps you remember stuff in 8086 assembly programming. I used it to pass my assembly exam :)

#### Content list

- [Code Structure](#basic-structure)
- [Intrupts](#intrupts)
  - [Working with strings](#strings--char)
  - [Working with files](#files-manipulation)
- [Procedures](#proc-far--near)
- [Time](#working-with-time)

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

### Char input without echo

Character input without echo to AL. if there is no character in the keyboard buffer, the function waits until any key is pressed.

note: Also there is a similar function that our teacher used once & has the same behavior of this function! It's `08h`. This interrupt moves the char into `AL` like the below example.

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

### Add dollar sign at end of string (Not Correct)

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

note: if CX is zero, no data is written, and the file is truncated or extended to the current position data is written beginning at the current file position, and the file position is updated after a successful write the usual cause for AX < CX on return is a full disk.

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

### Move the buffer/pointer in file

```asm
mov al,0
mov bx,handle
mov cx,0
mov dx,7
mov ah,42h
int 21h
```

### Get data len

```asm
data db "hello files!"
data_size=$-offset data
```

# Proc: Far & Near

procedure is near or far and must be one of the following:
Defining a proc as FAR tells the assembler that all Calls to that proc must give both a segment and a 16-bit offset. The upshot of this is that the FAR Call will save both IP and CS. There are two variants of RET: RETN and RETF. One will pull off IP and the other will pull of BOTH IP AND CS. Go figure which one, okay?

- none: The type defaults to NEAR.
- NEAR: Defines a near procedure; called with LCALL or ACALL.
- FAR: Defines a far procedure; called with ECALL. You should specify FAR if the procedure is called from a different 64KByte segment.
  you should use `call` and the proc name to run the proc...

**Diffrence between procs**: Near calls and returns transfer control between procedures in the same code segment. Far calls and returns pass control between different segments.

note:Near contains a 16-bit offset. For calls it will save the IP only. Far contains a segment and a 16-bit offset. For calls it will save IP and CS.

note: PROC specifies that the procedure is a standard procedure function.
Procedures must include a RET instruction which the assembler converts into one of the following machine return instructions:

- RETS: Return from far procedure.
- RETI: Return from interrupt procedure.
- RET: Return from near procedure.

Here it's a 2 proc far in a program example:

```asm
cds segment
    assume cs:cds,ds:dts,ss:stk
main proc far
    ; main code goes here
main endp
cds ends

procsg segment
    assume cs:procsg
example proc far
    ; proc far example
example endp
procsg ends
end main

```

## Working with time

we use `2ch` as the function to get time from DOS. It make DX, CX as the time now.
`CH = hour CL = minute DH = second DL = milliseconds`

Example:

```asm
mov ah, 2ch
int 21h
```
