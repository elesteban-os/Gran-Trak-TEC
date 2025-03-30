

include macros.asm


; --------------------------------------------------------------------------------
; bucle principal del programa
; --------------------------------------------------------------------------------
main_loop:
    ; Pequeño delay
    ;push cx
    ;mov cx, 0FFFFh
;delay_loop:
    ;loop delay_loop
    ;pop cx
    ; Mover jugador 1
    call move_player1
    ; Mover jugador 2
    call move_player2
    ; Mover bots
    call move_bot1
    call move_bot2
    call move_bot3
    ; Verificar teclas
    call check_keyboard
    
    jmp main_loop
    

; --------------------------------------------------------------------------------
; verificación de si hay una tecla presionada flechas de dirección
; --------------------------------------------------------------------------------
check_keyboard:
    ; Comprobar si hay una tecla presionada
    mov ah, 1
    int 16h
    jz main_loop         ; Si no hay tecla presionada, continuar con el bucle principal

    ; Leer la tecla
    mov ah, 0
    int 16h
    cmp ah, 16h          ; Código para tecla 'U'
    je jump_up
    cmp ah, 24h          ; Código para tecla 'J'
    je jump_down
    cmp ah, 23h          ; Código para tecla 'H'
    je jump_left
    cmp ah, 25h          ; Código para tecla 'K'
    je jump_right

    cmp ah, 17          ; Código para tecla 'W'
    je jump_up2
    cmp ah, 31          ; Código para tecla 'S'
    je jump_down2
    cmp ah, 30          ; Código para tecla 'A'
    je jump_left2
    cmp ah, 32          ; Código para tecla 'D'
    je jump_right2

    ret

jump_up:
    jmp move_up
jump_down:
    jmp move_down
jump_left:
    jmp move_left
jump_right:
    jmp move_right

jump_up2:
    jmp move_up2
jump_down2:
    jmp move_down2
jump_left2:
    jmp move_left2
jump_right2:
    jmp move_right2

move_up:
    mov J1_dx, 0    ; Sin movimiento horizontal
    mov J1_dy, -1   ; Mover hacia arriba
    ret

move_down:
    mov J1_dx, 0    ; Sin movimiento horizontal
    mov J1_dy, 1    ; Mover hacia abajo
    ret

move_left:
    mov J1_dx, -1   ; Mover hacia la izquierda
    mov J1_dy, 0    ; Sin movimiento vertical
    ret

move_right:
    mov J1_dx, 1    ; Mover hacia la derecha
    mov J1_dy, 0    ; Sin movimiento vertical
    ret

move_up2:
    mov J2_dx, 0    ; Sin movimiento horizontal
    mov J2_dy, -1   ; Mover hacia arriba
    ret

move_down2:
    mov J2_dx, 0    ; Sin movimiento horizontal
    mov J2_dy, 1    ; Mover hacia abajo
    ret

move_left2:
    mov J2_dx, -1   ; Mover hacia la izquierda
    mov J2_dy, 0    ; Sin movimiento vertical
    ret

move_right2:
    mov J2_dx, 1    ; Mover hacia la derecha
    mov J2_dy, 0    ; Sin movimiento vertical
    ret





; --------------------------------------------------------------------------------
; procesos
; --------------------------------------------------------------------------------
; Procedimiento para mover el jugador 1
move_player1 proc
    ; Borrar rectángulo actual
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 00h
    fill_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 00h

    ; Actualizar posición según dirección
    mov ax, J1_dx
    add J1_x1, ax
    add J1_x2, ax
    
    mov ax, J1_dy
    add J1_y1, ax
    add J1_y2, ax

    ; Detectar si hay colisiones
    mov player_n, 1

    mov ax, J1_x1
    add ax, 10
    mov Jx, ax
    
    mov ax, J1_y1
    add ax, 10
    mov Jy, ax

    ; Corregir lo de lappixel aqui
    collision1 J1_x1, J1_y1, player_n, lappixel
    collision1 Jx, J1_y1, player_n, lappixel
    collision1 J1_x1, Jy, player_n, lappixel
    collision1 J1_x2, J1_y2, player_n, lappixel

    ; Dibujar en nueva posición
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah
    fill_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah
    
    ret
move_player1 endp

; Procedimiento para mover el jugador 2
move_player2 proc
    ; Borrar rectángulo actual
    draw_rectangle J2_x1, J2_y1, J2_x2, J2_y2, 00h
    fill_rectangle J2_x1, J2_y1, J2_x2, J2_y2, 00h

    ; Actualizar posición según dirección
    mov ax, J2_dx
    add J2_x1, ax
    add J2_x2, ax
    
    mov ax, J2_dy
    add J2_y1, ax
    add J2_y2, ax

    ; Detectar si hay colisiones
    mov player_n, 2

    mov ax, J2_x1
    add ax, 10
    mov Jx, ax
    
    mov ax, J2_y1
    add ax, 10
    mov Jy, ax

    ; Detectar colisiones
    collision1 J2_x1, J2_y1, player_n
    collision1 Jx, J2_y1, player_n
    collision1 J2_x1, Jy, player_n
    collision1 J2_x2, J2_y2, player_n

    ; Detectar vueltas
    mov lappixel, 1
    lapDetection J2_x1, J2_y1, player_n
    mov lappixel, 2
    lapDetection J2_x2, J2_y2, player_n

    ; Dibujar en nueva posición
    draw_rectangle J2_x1, J2_y1, J2_x2, J2_y2, 0Bh
    fill_rectangle J2_x1, J2_y1, J2_x2, J2_y2, 0Bh
    ret
move_player2 endp

; Procedimiento para mover el BOT 1
move_bot1 proc
    
    ; Borrar posición actual
    draw_rectangle B1_x1, B1_y1, B1_x2, B1_y2, 00h
    fill_rectangle B1_x1, B1_y1, B1_x2, B1_y2, 00h

    push ax               ; Guardar el registro ax para mantener el modo grafico

    ; Calcular posición adelante (centro del bot + dirección*15)
    
    mov cx, B1_x1
    add cx, B1_x2
    shr cx, 1            ; CX = centro X
    mov dx, B1_y1
    add dx, B1_y2
    shr dx, 1            ; DX = centro Y

    push dx              ; Guardar dx que contiene la posición Y (porque imul modifica dx)
                         ; el resultado de imul se guarda en dx:ax parte alta y parte baja
    mov ax, B1_dx
    mov bx, 15
    imul bx
    add cx, ax           ; Añadir offset en X

    mov ax, B1_dy 
    imul bx
    pop dx               ; Recuperar dx que contiene la posición Y
    add dx, ax           ; Añadir offset en Y

    ; Guardar el color original
    mov ah, 0Dh          ; Función para leer pixel
    mov bh, 0            ; Página de video
    int 10h              ; Leer color del pixel
    mov bl, al           ; Guardar el color en bl
    
    ; Restaurar el color original
    mov ah, 0Ch          ; Función para escribir pixel
    mov al, bl           ; Recuperar el color original
    int 10h              ; Escribir el pixel

    pop ax               ; Recuperar el registro ax para mantener el modo grafico

    cmp bl, track_color  ; Comparar con el color de la pista
    je bot1_turn          ; Girar si no es el color de la pista

    ; Mover en la dirección actual si todo está bien
    mov ax, B1_dx
    add B1_x1, ax
    add B1_x2, ax
    
    mov ax, B1_dy
    add B1_y1, ax
    add B1_y2, ax
    
    jmp bot1_draw

bot1_turn:
    ; Girar 90 grados a la izquierda (rotación en sentido antihorario)
    ; dx, dy = dy, -dx
    
    mov ax, B1_dx 
    mov bx, B1_dy 
    mov B1_dx, bx 
    neg ax
    mov B1_dy, ax 

bot1_draw:
    ; Dibujar en nueva posición
    draw_rectangle B1_x1, B1_y1, B1_x2, B1_y2, 0Eh ;amarillo
    fill_rectangle B1_x1, B1_y1, B1_x2, B1_y2, 0Eh
    ret
move_bot1 endp

; Procedimiento para mover el BOT 2
move_bot2 proc
    
    ; Borrar posición actual
    draw_rectangle B2_x1, B2_y1, B2_x2, B2_y2, 00h
    fill_rectangle B2_x1, B2_y1, B2_x2, B2_y2, 00h

    push ax               ; Guardar el registro ax para mantener el modo grafico

    ; Calcular posición adelante (centro del bot + dirección*15)
    
    mov cx, B2_x1
    add cx, B2_x2
    shr cx, 1            ; CX = centro X
    mov dx, B2_y1
    add dx, B2_y2
    shr dx, 1            ; DX = centro Y

    push dx              ; Guardar dx que contiene la posición Y (porque imul modifica dx)
                         ; el resultado de imul se guarda en dx:ax parte alta y parte baja
    mov ax, B2_dx
    mov bx, 15
    imul bx
    add cx, ax           ; Añadir offset en X

    mov ax, B2_dy 
    imul bx
    pop dx               ; Recuperar dx que contiene la posición Y
    add dx, ax           ; Añadir offset en Y

    ; Guardar el color original
    mov ah, 0Dh          ; Función para leer pixel
    mov bh, 0            ; Página de video
    int 10h              ; Leer color del pixel
    mov bl, al           ; Guardar el color en bl
    
    ; Restaurar el color original
    mov ah, 0Ch          ; Función para escribir pixel
    mov al, bl           ; Recuperar el color original
    int 10h              ; Escribir el pixel

    pop ax               ; Recuperar el registro ax para mantener el modo grafico

    cmp bl, track_color  ; Comparar con el color de la pista
    je bot2_turn          ; Girar si no es el color de la pista

    ; Mover en la dirección actual si todo está bien
    mov ax, B2_dx
    add B2_x1, ax
    add B2_x2, ax
    
    mov ax, B2_dy
    add B2_y1, ax
    add B2_y2, ax
    
    jmp bot2_draw

bot2_turn:
    ; Girar 90 grados a la izquierda (rotación en sentido antihorario)
    ; dx, dy = dy, -dx
    
    mov ax, B2_dx 
    mov bx, B2_dy 
    mov B2_dx, bx 
    neg ax
    mov B2_dy, ax 

bot2_draw:
    ; Dibujar en nueva posición
    draw_rectangle B2_x1, B2_y1, B2_x2, B2_y2, 01h ;azul
    fill_rectangle B2_x1, B2_y1, B2_x2, B2_y2, 01h
    ret
move_bot2 endp

; Procedimiento para mover el BOT 3
move_bot3 proc
    
    ; Borrar posición actual
    draw_rectangle B3_x1, B3_y1, B3_x2, B3_y2, 00h
    fill_rectangle B3_x1, B3_y1, B3_x2, B3_y2, 00h

    push ax               ; Guardar el registro ax para mantener el modo grafico

    ; Calcular posición adelante (centro del bot + dirección*15)
    
    mov cx, B3_x1
    add cx, B3_x2
    shr cx, 1            ; CX = centro X
    mov dx, B3_y1
    add dx, B3_y2
    shr dx, 1            ; DX = centro Y

    push dx              ; Guardar dx que contiene la posición Y (porque imul modifica dx)
                         ; el resultado de imul se guarda en dx:ax parte alta y parte baja
    mov ax, B3_dx
    mov bx, 15
    imul bx
    add cx, ax           ; Añadir offset en X

    mov ax, B3_dy 
    imul bx
    pop dx               ; Recuperar dx que contiene la posición Y
    add dx, ax           ; Añadir offset en Y

    ; Guardar el color original
    mov ah, 0Dh          ; Función para leer pixel
    mov bh, 0            ; Página de video
    int 10h              ; Leer color del pixel
    mov bl, al           ; Guardar el color en bl
    
    ; Restaurar el color original
    mov ah, 0Ch          ; Función para escribir pixel
    mov al, bl           ; Recuperar el color original
    int 10h              ; Escribir el pixel

    pop ax               ; Recuperar el registro ax para mantener el modo grafico

    cmp bl, track_color  ; Comparar con el color de la pista
    je bot3_turn          ; Girar si no es el color de la pista

    ; Mover en la dirección actual si todo está bien
    mov ax, B3_dx
    add B3_x1, ax
    add B3_x2, ax
    
    mov ax, B3_dy
    add B3_y1, ax
    add B3_y2, ax
    
    jmp bot3_draw

bot3_turn:
    ; Girar 90 grados a la izquierda (rotación en sentido antihorario)
    ; dx, dy = dy, -dx
    
    mov ax, B3_dx 
    mov bx, B3_dy 
    mov B3_dx, bx 
    neg ax
    mov B3_dy, ax 

bot3_draw:
    ; Dibujar en nueva posición
    draw_rectangle B3_x1, B3_y1, B3_x2, B3_y2, 05h ;morado
    fill_rectangle B3_x1, B3_y1, B3_x2, B3_y2, 05h
    ret
move_bot3 endp



; --------------------------------------------------------------------------------
; finalización del programa
; --------------------------------------------------------------------------------
end_program:
    ;finalizar el programa  
    mov ah, 00h           ; Espera por una tecla antes de salir
    int 16h

    mov ah, 4Ch           ; Termina el programa
    int 21h

