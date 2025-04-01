; --------------------------------------------------------------------------------
; mostrar pantalla de inicio de juego
; --------------------------------------------------------------------------------
show_start_screen PROC
    call clear_screen

    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 10   ; Fila 10 
    MOV DL, 30   ; Columna 30
    INT 10h
    
    ; Mostrar título
    MOV AH, 09h
    LEA DX, title_msg
    INT 21h
    
    ; Saltar líneas
    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h

    MOV DL, 0Ah
    INT 21h

    MOV DL, 0Ah
    INT 21h

    MOV AH, 02h
    MOV BH, 0
    MOV DH, 14   ; Fila 14
    MOV DL, 33   ; Columna 33
    INT 10h
    
    ; Mostrar mensaje de inicio
    MOV AH, 09h
    LEA DX, start_msg
    INT 21h
    
    RET
show_start_screen ENDP

; --------------------------------------------------------------------------------
; esperar tecla 'X' para iniciar
; --------------------------------------------------------------------------------
wait_for_start PROC
    MOV AH, 00h
    INT 16h
    CMP AL, 'x'
    JE end_wait
    CMP AL, 'X'
    JNE wait_for_start
end_wait:
    call clear_screen
    RET
wait_for_start ENDP

; --------------------------------------------------------------------------------
; mostrar mensaje de ganador
; --------------------------------------------------------------------------------
show_winner PROC

    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 14   ; Fila 10 
    MOV DL, 32   ; Columna 32
    INT 10h
    
    ; Mostrar mensaje de ganador
    MOV AH, 09h
    LEA DX, winner_msg
    INT 21h
    
    CALL determine_winner
    CALL show_winner_aux
    
    ; Posicionar cursor para el mensaje "Presione c para continuar"
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 20   ; fila 20
    MOV DL, 30   ; columna 30
    INT 10h
    
    MOV AH, 09h
    LEA DX, continue_msg  
    INT 21h
    
    ; Esperar a que se presione 'c'
wait_for_c:
    MOV AH, 00h    ; Función para leer tecla
    INT 16h        ; Interrupción de teclado
    
    CMP AL, 'c'    ; Comparar con 'c'
    JE exit_winner
    CMP AL, 'C'    ; Comparar con 'C' (mayúscula)
    JE exit_winner
    
    JMP wait_for_c ; Si no es 'c', seguir esperando
    
exit_winner:
    RET
show_winner ENDP

; --------------------------------------------------------------------------------
; mostrar mensaje de ganador auxiliar
; --------------------------------------------------------------------------------
show_winner_aux PROC
    CMP AL, 1
    JNE winner_is_player2
    fill_rectangle 290, 250, 330, 260, 0Ah ; Color para jugador 1
    RET

winner_is_player2:
    CMP AL, 2
    JNE winner_is_bot1
    fill_rectangle 290, 250, 330, 260, 0Bh
    RET

winner_is_bot1:
    CMP AL, 3
    JNE winner_is_bot2
    fill_rectangle 290, 250, 330, 260, 0Eh
    RET

winner_is_bot2:
    CMP AL, 4
    JNE winner_is_bot3
    fill_rectangle 290, 250, 330, 260, 01h
    RET

winner_is_bot3:
    fill_rectangle 290, 250, 330, 260, 05h
    RET

show_winner_aux ENDP

; --------------------------------------------------------------------------------
; mostrar pantalla de fin de juego
; --------------------------------------------------------------------------------
show_end_screen PROC
    ; Limpiar pantalla
    ;CALL clear_screen
    ;CALL exit_video_mode
    CALL clear_screen

    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 12   ; Fila 10 
    MOV DL, 31   ; Columna 32
    INT 10h
    
    ; Mostrar mensaje GAME OVER
    MOV AH, 09h
    LEA DX, game_over_msg
    INT 21h
    
    ; Esperar tecla para salir
    MOV AH, 00h
    INT 16h
    
    RET
show_end_screen ENDP

; --------------------------------------------------------------------------------
; limpiar pantalla
; --------------------------------------------------------------------------------
clear_screen PROC
    MOV AX, 0600h
    MOV BH, 07h
    MOV CX, 0000h
    MOV DX, 184Fh
    INT 10h
    
    MOV AH, 02h
    MOV BH, 0
    MOV DX, 0000h
    INT 10h
    
    RET
clear_screen ENDP

; --------------------------------------------------------------------------------
; restaurar modo de video al por defecto
; --------------------------------------------------------------------------------
exit_video_mode PROC
    PUSH AX
    
    ; Restaurar modo texto estándar
    MOV AH, 00h     ; Función para establecer modo de video
    MOV AL, 03h     ; Modo texto 80x25, 16 colores
    INT 10h         ; Llamar a BIOS
    
    ; Opcional: Limpiar pantalla
    MOV AX, 0600h   ; Función scroll up
    MOV BH, 07h     ; Atributo normal (gris claro sobre negro)
    MOV CX, 0000h   ; Esquina superior izquierda (0,0)
    MOV DX, 184Fh   ; Esquina inferior derecha (24,79)
    INT 10h
    
    POP AX
    RET
exit_video_mode ENDP

; --------------------------------------------------------------------------------
; Procedimiento para determinar el ganador basado en lapcounter

; --------------------------------------------------------------------------------
determine_winner PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV SI, 0            ; Índice para lapcounter
    MOV CX, 5            ; 5 jugadores para comparar
    MOV BX, 0            ; Valor máximo encontrado
    MOV AL, 0            ; Jugador con mayor puntuación     ; Salida: AL = número del jugador ganador (1-5)
    MOV AH, 1            ; Contador de jugador actual
    
find_max_loop:
    MOV DX, lapcounter[SI] ; Cargar valor actual
    
    CMP DX, BX           ; Comparar con máximo actual
    JLE not_max          ; Si es menor o igual, no es nuevo máximo
    
    MOV BX, DX           ; Actualizar máximo
    MOV AL, AH           ; Guardar número de jugador
    
not_max:
    ADD SI, 2            ; Avanzar al siguiente valor (word = 2 bytes)
    INC AH               ; Incrementar contador de jugador
    LOOP find_max_loop   ; Repetir hasta revisar todos
    
    ; AL ahora contiene el número del jugador ganador (1-5)
    
    POP SI
    POP DX
    POP CX
    POP BX
    RET
determine_winner ENDP