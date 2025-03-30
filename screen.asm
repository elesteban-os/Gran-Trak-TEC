; --------------------------------------------------------------------------------
; mostrar pantalla de fin de juego
; --------------------------------------------------------------------------------
show_end_screen PROC
    ; Limpiar pantalla
    CALL clear_screen

    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 10   ; Fila 10 
    MOV DL, 32   ; Columna 32
    INT 10h
    
    ; Mostrar mensaje GAME OVER
    MOV AH, 09h
    LEA DX, game_over_msg
    INT 21h
    
    ; Saltar línea
    MOV AH, 02h
    MOV DL, 0Dh
    INT 21h
    MOV DL, 0Ah
    INT 21h

    MOV AH, 02h
    MOV BH, 0
    MOV DH, 16   ; Fila 17
    MOV DL, 33   ; Columna 33
    INT 10h
    
    ; Mostrar THE WINNER IS
    MOV AH, 09h
    LEA DX, winner_msg
    INT 21h
    
    ; Esperar tecla para salir
    MOV AH, 00h
    INT 16h
    
    RET
show_end_screen ENDP

; --------------------------------------------------------------------------------
; mostrar pantalla de inicio de juego
; --------------------------------------------------------------------------------
show_start_screen PROC
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
    RET
wait_for_start ENDP

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