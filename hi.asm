IDEAL
MODEL small
STACK 100h
DATASEG
    Clock equ es:6Ch
    pos dw 0
    sodoRand db 0 
    x1 dw 42
    y1 dw 12
	x2 dw 44
    y2 dw 12
	x3 dw 40
    y3 dw 12

CODESEG
proc blackScreen
    xor ax, ax
    mov di, 0
    mov al, ' '
    mov ah, 0

black:
    mov [es:di], ax
    add di, 2
    cmp di, 2 * (25 * 80)
    jnz black

    mov di, 0
    mov ax, 0

    ret
endp blackScreen

proc drow2
	mov bx , y1
	mov y2 ,bx
	mov bx,x1
	mov x2,bx

    xor bx, bx
    mov ax,80
    mov di,y1
    mul di
    mov di,ax
    add di,x1
    mov ax,2
    mul di
    mov di,ax
    mov bl, '*'
    mov bh, 125
    mov [es:di], bx
    ret
endp drow2

proc drow3
	mov bx , y2
	mov y3 ,bx
	mov bx,x2
	mov x3,bx
    xor bx, bx
    mov ax,80
    mov di,y3
    mul di
    mov di,ax
    add di,x3
    mov ax,2
    mul di
    mov di,ax
    mov bl, '*'
    mov bh, 125
    mov [es:di], bx
    ret
endp drow3
proc RandLoop
    mov ax, [Clock] 
    mov bx,sodoRand
    mov dx, [ cs:bx] 
    xor dx, ax 
    and dx, 2000 
    inc sodoRand
    mov pos , dx
    call drow
    RandLoop
endp
start:
    mov ax, @data
    mov ds, ax
    mov ax, 0b800h
    mov es, ax
    call blackScreen

inputLoop:
    mov ah, 1
    int 21h
    cmp al, 'q' 
    jz exit
    cmp al, 'w' 
    jz moveUp
    cmp al, 's' 
    jz moveDown
    cmp al, 'a' 
    jz moveLeft
    cmp al, 'd' 
    jz moveRight
    jmp inputLoop ; Continue looping for input

moveUp:
    cmp y1,0
    jz inputLoop
    call blackScreen
	call drow3
	call drow2
    dec y1
	call drow2
    jmp inputLoop

moveDown:
    cmp y1,24
    jz inputLoop
    call blackScreen
	call drow3
	call drow2
    inc y1
	call drow2
    jmp inputLoop

moveLeft:
    cmp x1,0
    jz inputLoop
    call blackScreen
	call drow3
	call drow2
    dec x1
	call drow2
    jmp inputLoop

moveRight:
    cmp x1,79
    jz inputLoop
    call blackScreen
	call drow3
	call drow2
    inc x1
	call drow2
    jmp inputLoop

exit:
    mov ax, 4c00h
    int 21h

END start
