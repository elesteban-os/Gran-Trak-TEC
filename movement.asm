

include macros.asm


; --------------------------------------------------------------------------------
; bucle principal del programa
; --------------------------------------------------------------------------------
main_loop:
    ; Mover jugador 1
    call move_player1
    ; Mover jugador 2
    call move_player2
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

    ; Dibujar en nueva posición
    draw_rectangle J2_x1, J2_y1, J2_x2, J2_y2, 0Bh
    fill_rectangle J2_x1, J2_y1, J2_x2, J2_y2, 0Bh
    ret
move_player2 endp

; --------------------------------------------------------------------------------
; finalización del programa
; --------------------------------------------------------------------------------
end_program:
    ;finalizar el programa  
    mov ah, 00h           ; Espera por una tecla antes de salir
    int 16h

    mov ah, 4Ch           ; Termina el programa
    int 21h

