.MODEL SMALL
.STACK 100h

.DATA
    ; Pantalla de inicio
    title_msg DB "GRAN TRAK  -  TEC EDITION$"
    start_msg DB " Press X to start$"
    
    ; Pantalla de fin
    game_over_msg DB "G A M E  O V E R$"
    winner_msg DB "The winner is:$"
    
    ; Variables de tiempo
    current_time DB "02:00$"    ; string para mostrar el tiempo
    seconds DW 0                ; segundos requedidos
    minutes DW 2                ; minutos requedidos
    finished DB 0               ; bandera de tiempo finalizado

.CODE
MAIN PROC
    ; Inicialicion del segmento de datos
    MOV AX, @DATA
    MOV DS, AX
    
    ; Mostrar pantalla de inicio
    CALL clear_screen
    CALL show_start_screen
    
    ; Esperar tecla 'X' para inciar
    CALL wait_for_start
    CALL clear_screen
    
; Bucle principal de temporizador
timer_loop:

    ; Verifica tecla ESC para salir interrumpiendo el programa
    MOV AH, 01h
    INT 16h
    JZ check_timer
    
    MOV AH, 00h
    INT 16h
    CMP AL, 27      ; ESC
    JE exit

check_timer:
    CALL update_time
    CALL display_time
    CALL check_time_finished
    
    ; Verifica si tiempo termino
    CMP [finished], 1
    JE show_end
    
    ; Espera 1 segundo aproximadamente
    MOV AH, 0
    INT 1Ah
    MOV BX, DX

wait_tick:
    MOV AH, 0
    INT 1Ah
    SUB DX, BX
    CMP DX, 18
    JB wait_tick
    
    ; Decrementa el tiempo
    CALL decrement_time
    
    JMP timer_loop

show_end:
    CALL show_end_screen
    JMP exit

exit:
    ; Terminar programa
    MOV AX, 4C00h
    INT 21h
MAIN ENDP

; Procedimiento para decrementar tiempo
decrement_time PROC
    CMP [seconds], 0
    JNE dec_seconds
    
    CMP [minutes], 0
    JE end_decrement
    
    DEC [minutes]
    MOV [seconds], 59
    JMP end_decrement
    
dec_seconds:
    DEC [seconds]
    
end_decrement:
    RET
decrement_time ENDP

; Procedimiento para verificar tiempo finalizado
check_time_finished PROC
    CMP [minutes], 0
    JNE not_finished
    CMP [seconds], 0
    JNE not_finished
    
    ; Si llegamos aquí, el tiempo se ha agotado
    MOV [finished], 1
    
not_finished:
    RET
check_time_finished ENDP

; Procedimiento para mostrar pantalla de fin de juego
show_end_screen PROC
    ; Limpiar pantalla
    CALL clear_screen

    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 10   ; Fila 10 
    MOV DL, 32   ; Columna 25
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
    MOV DH, 17   ; Fila 10 
    MOV DL, 33   ; Columna 25
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

; Procedimiento mostrar pantalla de inicio
show_start_screen PROC
    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DH, 10   ; Fila 10 
    MOV DL, 30   ; Columna 25
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
    MOV DH, 14   ; Fila 10 
    MOV DL, 33   ; Columna 25
    INT 10h
    
    ; Mostrar mensaje de inicio
    MOV AH, 09h
    LEA DX, start_msg
    INT 21h
    
    RET
show_start_screen ENDP

; Esperar tecla 'X' para iniciar
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

; Procedimiento para limpiar la pantalla
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

; Procedimiento para actualizar el string de tiempo
update_time PROC
    ; Convertir minutos a ASCII
    MOV AX, [minutes]
    MOV BL, 10
    DIV BL
    ADD AL, '0'
    MOV [current_time], AL
    ADD AH, '0'
    MOV [current_time+1], AH
    
    ; Convertir segundos a ASCII
    MOV AX, [seconds]
    DIV BL
    ADD AL, '0'
    MOV [current_time+3], AL
    ADD AH, '0'
    MOV [current_time+4], AH
    
    RET
update_time ENDP

; Procedimiento para mostrar el tiempo en pantalla
display_time PROC
    ; Mover cursor
    MOV AH, 02h
    MOV BH, 0  ; Página 0
    MOV DH, 1  ; Fila 0
    MOV DL, 73 ; Columna 74 en Hexadecimal (116 en decimal) 
    INT 10h
    
    ; Mostrar cadena de tiempo
    MOV AH, 09h
    LEA DX, current_time
    INT 21h
    
    RET
display_time ENDP

END MAIN