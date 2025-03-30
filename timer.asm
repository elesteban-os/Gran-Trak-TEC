; --------------------------------------------------------------------------------
; procedimiento para decrementar el tiempo
; --------------------------------------------------------------------------------
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

; --------------------------------------------------------------------------------
; procedimiento para verificar si el tiempo ha terminado
; --------------------------------------------------------------------------------
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

; --------------------------------------------------------------------------------
; procedimiento para actualizar el string de tiempo
; --------------------------------------------------------------------------------
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

; --------------------------------------------------------------------------------
; procedimiento para mostrar el tiempo en pantalla
; --------------------------------------------------------------------------------
display_time PROC
    ; Mover cursor
    MOV AH, 02h
    MOV BH, 0  ; Página 0
    MOV DH, 1  ; Fila 1
    MOV DL, 73 ; Columna 73
    INT 10h
    
    ; Mostrar cadena de tiempo
    MOV AH, 09h
    LEA DX, current_time
    INT 21h
    
    RET
display_time ENDP

; --------------------------------------------------------------------------------
; procedimiento para inicializar el temporizador
; --------------------------------------------------------------------------------
init_timer PROC
    ; Guardar el tick actual como referencia
    MOV AH, 0
    INT 1Ah
    MOV [lastTick], DX
    
    ; Inicializar variables de tiempo si es necesario
    MOV [minutes], 1            ; 1 minuto por defecto
    MOV [seconds], 30            ; 0 segundos por defecto
    MOV [finished], 0
    
    ; Actualizar la visualización inicial
    CALL update_time
    CALL display_time
    
    RET
init_timer ENDP


; --------------------------------------------------------------------------------
; procedimiento para actualizar el temporizador ; Retorna: AX = 0 (sin cambios), 1 (tiempo acabado), 2 (ha pasado un segundo)
; --------------------------------------------------------------------------------
update_timer PROC   
    PUSH BX
    PUSH DX
    
    ; Verificar si el tiempo ya terminó
    CMP [finished], 1
    JNE check_elapsed_time
    
    MOV AX, 1    ; El tiempo ya terminó
    JMP end_update_timer
    
check_elapsed_time:
    ; Obtener el tick actual
    MOV AH, 0
    INT 1Ah
    
    ; Comparar con el último tick guardado
    MOV BX, DX
    SUB BX, [lastTick]
    
    ; Si ha pasado menos de 18 ticks (~1 segundo), no hacer nada
    CMP BX, 18
    JB no_time_change
    
    ; Actualizar el último tick
    MOV [lastTick], DX
    
    ; Decrementar el tiempo
    CALL decrement_time
    
    ; Actualizar visualización y verificar si terminó
    CALL update_time
    CALL display_time
    CALL check_time_finished
    
    ; Verificar si el tiempo terminó después de esta actualización
    CMP [finished], 1
    JNE time_updated
    
    MOV AX, 1    ; El tiempo terminó
    JMP end_update_timer
    
time_updated:
    MOV AX, 2    ; Ha pasado un segundo
    JMP end_update_timer
    
no_time_change:
    MOV AX, 0    ; No ha pasado tiempo suficiente
    
end_update_timer:
    POP DX
    POP BX
    RET
update_timer ENDP
