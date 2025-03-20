.model small
.data

; --------------------------------------------------------------------------------
; variables
; --------------------------------------------------------------------------------
; Variables para almacenar las coordenadas del rectángulo
J1_x1 dw 310
J1_x2 dw 320
J1_y1 dw 230
J1_y2 dw 240

; --------------------------------------------------------------------------------
; macros 
; --------------------------------------------------------------------------------

pinta_pixel macro x, y, color
    mov ah, 0Ch          ; Función de BIOS para pintar un píxel
    mov al, color       
    mov bh, 00h          ; Página de pantalla (0)
    mov cx, x           
    mov dx, y            
    int 10h              
endm

; Macro para pintar un rectangulo en la pantalla
draw_rectangle macro x1, y1, x2, y2, color 
    LOCAL p_hor_upperLine, p_hor_bottomLine, p_vert_leftLine, p_vert_rightLine
        ; Pinta la línea horizontal superior
        mov cx, x1
        mov dx, y1
    p_hor_upperLine:
        pinta_pixel cx, dx, color  
        inc cx
        cmp cx, x2
        jle p_hor_upperLine
        ; Pinta la línea horizontal inferior
        mov cx, x1
        mov dx, y2
    p_hor_bottomLine:
        pinta_pixel cx, dx, color
        inc cx
        cmp cx, x2
        jle p_hor_bottomLine
        ; Pinta la línea vertical izquierda
        mov cx, x1
        mov dx, y1
    p_vert_leftLine:
        pinta_pixel cx, dx, color
        inc dx
        cmp dx, y2
        jle p_vert_leftLine
        ; Pinta la línea vertical derecha
        mov cx, x2
        mov dx, y1
    p_vert_rightLine:
        pinta_pixel cx, dx, color 
        inc dx
        cmp dx, y2
        jle p_vert_rightLine
endm

.code
; --------------------------------------------------------------------------------
; inicialización de lo necesario para iniciar el programa
; --------------------------------------------------------------------------------
start:
    
    mov ax, @data
    mov ds, ax

    ; Establecer el modo gráfico
    mov ah, 00h           ; Función 00h: Establecer modo de video o "modo gráfico"
    mov al, 12h           ; Modo gráfico 12h: 640x480, 16 colores
    int 10h               ; Llamada a la interrupción para establecer el modo gráfico

    ; Pintar un rectángulo en posicion inicial
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah

; --------------------------------------------------------------------------------
; bucle principal del programa
; --------------------------------------------------------------------------------
main_loop:
    jmp check_keyboard

; --------------------------------------------------------------------------------
; verificación de si hay una tecla presionada flechas de dirección
; --------------------------------------------------------------------------------
check_keyboard:
    ; Comprobar si hay una tecla presionada
    mov ah, 1
    int 16h
    jz main_loop        ; Si no hay tecla presionada, vuelve al bucle principal

    ; Leer la tecla
    mov ah, 0
    int 16h
    cmp ah, 72          ; Código para flecha arriba
    je jump_up
    cmp ah, 80          ; Código para flecha abajo
    je jump_down
    cmp ah, 75          ; Código para flecha izquierda
    je jump_left
    cmp ah, 77          ; Código para flecha derecha
    je jump_right

    ; Si no es una tecla de flecha, vuelve al bucle principal
    jmp main_loop

jump_up:
    jmp move_up
jump_down:
    jmp move_down
jump_left:
    jmp move_left
jump_right:
    jmp move_right

move_up:
    ; borrar el rectángulo actual (pintar de color negro)
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 00h

    dec J1_y1           ; Reducir coordenada Y inicial de la linea
    dec J1_y2           ; Reducir coordenada Y final de la linea
    ;cmp y_pos, 0
    ;je y_pos_limit_up

    ; dibujar el rectángulo en la nueva posición
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah
    jmp main_loop

move_down:
    ; borrar el rectángulo actual (pintar de color negro)
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 00h

    inc J1_y1           ; Aumentar coordenada Y inicial de la linea
    inc J1_y2           ; Aumentar coordenada Y final de la linea
    ;cmp y_pos, 360
    ;je y_pos_limit_down

    ; dibujar el rectángulo en la nueva posición
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah
    jmp main_loop

move_left:
    ; borrar el rectángulo actual (pintar de color negro)
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 00h

    dec J1_x1           ; Reducir coordenada X inicial de la linea
    dec J1_x2           ; Reducir coordenada X final de la linea
    ;cmp x_pos, 15
    ;je x_pos_limit_left

    ; dibujar el rectángulo en la nueva posición
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah
    jmp main_loop

move_right:
    ; borrar el rectángulo actual (pintar de color negro)
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 00h
    
    inc J1_x1           ; Aumentar coordenada X inicial de la linea
    inc J1_x2           ; Aumentar coordenada X final de la linea
    ;cmp x_pos, 450
    ;je x_pos_limit_right

    ; dibujar el rectángulo en la nueva posición
    draw_rectangle J1_x1, J1_y1, J1_x2, J1_y2, 0Ah
    jmp main_loop

; --------------------------------------------------------------------------------
; finalización del programa
; --------------------------------------------------------------------------------
end_program:
    ;finalizar el programa  
    mov ah, 00h           ; Espera por una tecla antes de salir
    int 16h

    mov ah, 4Ch           ; Termina el programa
    int 21h

end start