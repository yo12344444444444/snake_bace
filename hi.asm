IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
CODESEG

proc blackScreen

	xor ax, ax 
	mov di, 0
	mov al, ' '
	mov ah, 0
	
	black:
		mov [es:di], ax
		add di, 2
		cmp di, 2*(25*80)
		jnz black
		
	mov di, 0
	mov ax, 0

	ret
endp blackScreen

proc moveUp

	mov al, ' '
	mov ah, 0
	mov [es:di], ax
	sub di, 160
	
	mov al, '*'
	mov ah, 255
	mov [es:di], ax

	ret
endp moveUp

proc moveDown

	mov al, ' '
	mov ah, 0
	mov [es:di], ax
	add di, 160
	
	mov al, '*'
	mov ah, 255
	mov [es:di], ax

	ret
endp

proc moveLeft

	mov al, ' '
	mov ah, 0
	mov [es:di], ax
	sub di, 2
	
	mov al, '*'
	mov ah, 255
	mov [es:di], ax

	ret
endp

proc moveRight

	mov al, ' '
	mov ah, 0
	mov [es:di], ax
	add di, 2

	mov al, '*'
	mov ah, 255
	mov [es:di], ax

	ret
endp

proc upperLimit
	
	mov cx, 0
	loop_upperLimit:
		cmp di, cx
		jz compareS

		inc cx
		cmp cx, 160
		jnz loop_upperLimit
	
	ret
endp

proc lowerLimmit

	mov cx, 160*24
	loop_lowerLimit:
		cmp di, cx
		jz compareA
		
		inc cx
		cmp cx, 160*25
		jnz loop_lowerLimit

	ret
endp

proc leftLimit

	mov cx, 0
	loop_leftLimit:
		cmp di, cx
		jz compareD

		add cx, 160
		cmp cx, 2*(24*80)
		jnz loop_leftLimit

	ret
endp

proc rightLimit
	
	mov cx, 160
	loop_rightLimit:
		cmp di, cx
		jz infinityLoop

		add cx, 160
		cmp cx, 2*(25*80)
		jnz loop_rightLimit
	
	ret
endp

proc delay

	mov cx, 0
	mov dx, 0
	
	counting2:
		inc cx
		cmp cx, 05h
		jz counting
		jnz counting2
	
	counting:
		mov cx, 0
		cmp dx, 50
		jz start
		inc dx
		jnz counting2
		

	ret
endp delay

start:
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
; --------------------------
; Your code here

;call blackScreen

mov di, 0
mov di, 2*(20*50)
mov al, '*'
mov ah, 255
mov [es:di], ax

	
infinityLoop:

	mov ah, 0
	int 16h

	compareW:
		cmp al, 'w'
		jnz compareS
		call upperLimit
		call moveUp

	compareS:
		cmp al, 's'
		jnz compareA
		call lowerLimmit
		call moveDown

	compareA:
		cmp al, 'a'
		jnz compareD
		call leftLimit
		call moveLeft
	
	compareD:
		cmp al, 'd'
		jnz infinityLoop
		call rightLimit
		call moveRight
	
jmp infinityLoop

; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start
