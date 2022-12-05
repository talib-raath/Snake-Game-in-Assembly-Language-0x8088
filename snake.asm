;Printing a snake at random position and start moving
[org 0x0100]
jmp start
x_pos: dw 0
y_pos: dw 0
foodpos: dw 0

welcome: db 'Welcome to Snake Game'
GroupMember1: db 'Group Members Talib Husain | 21F-9070 Saad Rehman | 21F-9640 Press Space to continue'
GameInstuction: db 'Welcome to snake Game Instructions The player uses the arrow keys to move a snake around the board Snake will eat food to increase its size and scores Press any key to continue'

GameOver: db 'Game Over'
currScore: db '0'
score: db 'Score: '
snake: db 02,'*','*','*','*'
snake_length: dw 5
;///////////////////////////////////////////////////////////////////////////////////

;code to clear the screen
clearscreen:
    push es
    push ax
    push di
    push cx
    mov ax,0xb800 ; video memory address
    mov es,ax
    mov ax,0x0720 ; color code and space ASCII
    mov di,0
    nextchar:
        mov [es:di],ax
        add di,2
        cmp di,4000
        jne nextchar

    ;popping all values
    pop cx
    pop di
    pop ax
    pop es
    ret
;///////////////////////////////////////////////////////////////////////////////////
welcomeMsg:
	push ax
	push bx
	push si
	push di
	push es
	push cx
	
	mov ax,0xb800
	mov es,ax
	mov di,1180
	mov si,GroupMember1
	mov cx,84
	mov ah,0x04
	cld
    newchar: 
	lodsb ; load next char in al
	stosw ; print char/attribute pair

	cmp cx,71
	jne x
	add word di,120

	x:
	cmp cx,47
	jne y
	add word di,114

	y:
	cmp cx,24
	jne next
	add word di,274

	next:
	loop newchar

	pop cx
	pop es
	pop di
	pop si
	pop bx
	pop ax
    ret

;///////////////////////////////////////////////////////////////////////////////////
Instruction:
	push ax
	push bx
	push si
	push di
	push es
	push cx
	
	mov ax,0xb800
	mov es,ax
	mov di,1180
	mov si,GameInstuction
	mov cx,172
	mov ah,0x04

    newcharins: 
	lodsb ; load next char in al
	stosw ; print char/attribute pair

	cmp cx,152
	jne x2
	add word di,120

	x2:
	cmp cx,138
	jne y2
	add word di,114

	y2:
	cmp cx,91
	jne z2
	add word di,66

	z2:
	cmp cx,43
	jne a2
	add word di,80

	a2:
	cmp cx,23
	jne next2
	add word di,120

	
	next2:
	loop newcharins

	pop cx
	pop es
	pop di
	pop si
	pop bx
	pop ax
 ret

;///////////////////////////////////////////////////////////////////////////////////
draw_snake:
    push bp
    mov bp, sp
    push ax
    push bx
    push si
    push cx
    push dx

    mov si, [bp + 6]        
    mov cx, 5        
    mov di, 1500
    mov ax, 0xb800
    mov es, ax

    mov bx, [bp + 4]
    mov ah, 0x04
    snake_next_part:
        mov al, [si]
        mov [es:di], ax
        mov [bx], di
        inc si
        add bx, 2

        add di, 2
        loop snake_next_part

    pop dx
    pop cx
    pop si
    pop bx
    pop ax
    pop bp
    ret 6
;///////////////////////////////////////////////////////////////////////////////////

printScore:
    push ax
    push bx
    push cx
    push si
    push di
    push es

    mov si,score
    mov ax,0xb800
    mov ah,0x07
    mov di,164
    mov cx,7
    p:
        lodsb
        stosw
    loop p
    mov al,[currScore]
    mov [es:di],ax
    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret


;////////////////////////////////////////////////////////////////////////////////////
move_snake_left:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            
    mov dx, [bx]

    mov cx, [bp + 8]
    sub dx, 2
    check_left_colision:
        cmp dx, [bx]
        je no_left_movement
        add bx, 2
        loop check_left_colision
    left_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di],ax
    left_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop left_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    no_left_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

;///////////////////////////////////////////////////////////////////////////////////
;SubRoutine for Up movement
move_snake_up:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]

    sub dx, 160

    check_up_colision:
        cmp dx, [bx]
        je no_up_movement
        add bx, 2
        loop check_up_colision

    upward_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    sub dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di],ax             ;snake head placed

    mov cx, [bp + 8]
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di],ax
    up_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop up_location_sort

    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax
    no_up_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;///////////////////////////////////////////////////////////////////////////////////
move_snake_down:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
     ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    add dx, 160
    check_down_colision:
        cmp dx, [bx]
        je no_down_movement
        add bx, 2
        loop check_down_colision

    downward_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 160
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di],ax
    down_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        loop down_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    no_down_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;///////////////////////////////////////////////////////////////////////////////////
move_snake_right:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push es
    push di
    push si
    ;snake_parts colision detection
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]

    mov cx, [bp + 8]
    add dx, 2
    check_right_colision:
        cmp dx, [bx]
        je no_right_movement
        add bx, 2
        loop check_right_colision

    right_movement:
    mov si, [bp + 6]            ;snake 
    mov bx, [bp + 4]            ;snake location
    mov dx, [bx]
    add dx, 2
    mov di, dx

    mov ax, 0xb800
    mov es, ax
    mov ah, 0x04
    mov al, [si]
    mov [es:di], ax             ;snake head placed

    mov cx, [bp + 8]            ;snake length
    mov di, [bx]
    inc si
    mov ah, 0x04
    mov al, [si]
    mov [es:di],ax
    right_location_sort:
        mov ax, [bx]
        mov [bx], dx
        mov dx, ax
        add bx, 2
        
        loop right_location_sort
    mov di, dx
    mov ax, 0x0720
    mov [es:di], ax

    no_right_movement:
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;///////////////////////////////////////////////////////////////////////////////////

play_game:
    call clearscreen
    call welcomeMsg
    mov ah,00
    int 16h
    call clearscreen
    call Instruction
    mov ah,00
    int 16h

    call clearscreen
    call draw_border

    push word [snake_length]
    mov bx, snake
    push bx
    mov bx, snake_locations
    push bx
    call draw_snake
    call displayFood

    repeat:
    
    call printScore
    mov ah,0
    int 0x16
    cmp ah,0x48
    je up
    cmp ah,0x4B
    je left
    cmp ah,0x4D
    je right
    cmp ah,0x50
    je down
    cmp ah,1
    jne repeat      
    mov ah,0x4c
    je exit
    up:
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_up
 		jmp new


    down:
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_down
		jmp new


    left:
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_left
		jmp new

    right:
        push word [snake_length]
        mov bx, snake
        push bx
        mov bx, snake_locations
        push bx
        call move_snake_right
	new:
         call check_death
        
          push ax
          mov ax,word[foodpos]
          cmp ax,[snake_locations]
          jne f
          call displayFood
          add word[snake_length],1
          add byte[currScore],1

        f:
            pop ax
        jmp repeat
    exit:
        pop bx
        pop ax
        ret

;////////////////////////////////////////////////////////////////////////////////
displayFood:
    push bx
    push ax
    push cx
    push dx
    push es
    push di

  l1:
    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx
    xor  dx, dx
    mov  cx, 25    
    div  cx      

    mov word[x_pos],dx

    MOV AH, 00h  ; interrupts to get system time        
    INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

    mov  ax, dx
    xor  dx, dx
    mov  cx, 80    
    div  cx       ; here dx contains the remainder of the division - from 0 to 9

    mov word[y_pos],dx

    mov ax,[x_pos]
    mov bx,80
    mul bx
    add ax,[y_pos]
    shl ax,1
    cmp ax,3840

 jg l1

    cmp ax,190
    jb l1

    mov word[foodpos],ax
    mov di,ax
    mov ax,0xb800
    mov es,ax
    mov ax,0x072A
    mov [es:di],ax


    pop di
    pop es
    pop dx
    pop cx
    pop ax
    pop bx
    ret


;////////////////////////////////////////////////////////////////////////////////////
draw_border:
	push ax
	push bx
	push es
	push di
	push si
	push cx

	mov ax,0xb800
	mov es,ax
	mov di,0

	mov cx,80
	mov ah,0x02
	mov al,'='
	top_border:
		mov [es:di],ax
		add di,2
		loop top_border

	mov cx,80
	mov di,3840
	mov al,'='
	bottom_border:
		mov [es:di],ax
		add di,2
		loop bottom_border

	mov cx,24
	mov al,'|'
	mov di,160
	left_border:
		mov [es:di],ax
		add di,160
		loop left_border

	mov cx,24
	mov al,'|'
	mov di,158
	right_border:
		mov [es:di],ax
		add di,160
		loop right_border

	pop cx
	pop si
	pop di
	pop es
	pop bx
		pop ax
    ret
;/////////////////////////////////////////////////////////////////////////////////////

check_death:
    push ax
    push di
    push cx

    mov ax, [snake_locations]
    cmp ax, 160
    jb finished
    mov di, 160              
    mov cx, 24

    check1: 
        cmp ax, di
        je finished
        add di, 158
        cmp ax, di
        je finished
        add di, 2

        loop check1 
    
    mov di,3840
    cmp ax, di
    ja finished
    jmp else

    finished:
    call over
    else:
        pop cx
        pop di
        pop ax
    ret
;///////////////////////////////////////////////////////////////////////
over:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push es
    push si
    push di
        call clearscreen
        mov ax,0xb800
        mov ah,0x04
        mov si,GameOver
        mov cx,9
        mov di,1510
        printMsg:
            lodsb
            stosw
            loop printMsg
    pop di
    pop si
    pop es
    pop cx
    pop bx
    pop ax
    pop bp
    mov ax, 0x4c00
    int 0x21
    ret
;/////////////////////////////////////////////////////////////////////////////////////

start:
call play_game
mov ax,0x4c00
int 0x21
snake_locations: dw 0