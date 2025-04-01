; --------------------------------------------------------------------------------
; Procedimiento para mostrar los nombres de los jugadores con rectángulos de color
; --------------------------------------------------------------------------------
display_player_names PROC
    PUSH AX
    PUSH BX
    PUSH DX

    ; Mostrar el texto del layout
    MOV AH, 02h
    MOV DH, 0        ; Fila 1
    MOV DL, 1        ; Columna 1
    INT 10h
    
    MOV AH, 09h
    LEA DX, lap_text
    INT 21h
    
    ; Jugador 1
    MOV AH, 02h      ; Función para posicionar cursor
    MOV BH, 0        ; Página 0
    MOV DH, 1        ; Fila 2
    MOV DL, 1        ; Columna 1
    INT 10h
    
    MOV AH, 09h      ; Función para mostrar cadena
    LEA DX, player1_name
    INT 21h
    
    ; Dibujar rectángulo para Jugador 1
    fill_rectangle 80, 19, 90, 25, 0Ah  
    
    ; Jugador 2
    MOV AH, 02h
    MOV DH, 2        ; Fila 3
    MOV DL, 1        ; Columna 1
    INT 10h
    
    MOV AH, 09h
    LEA DX, player2_name
    INT 21h
    
    ; Dibujar rectángulo para Jugador 2 (color azul, por ejemplo)
    fill_rectangle 80, 35, 90, 41, 0Bh  ; Coordenadas ajustadas y color azul
    
    ; Bot 1
    MOV AH, 02h
    MOV DH, 3        ; Fila 4
    MOV DL, 1        ; Columna 1
    INT 10h
    
    MOV AH, 09h
    LEA DX, bot1_name
    INT 21h
    
    ; Dibujar rectángulo para Bot 1 (color verde, por ejemplo)
    fill_rectangle 80, 51, 90, 57, 0Eh  ; Color verde
    
    ; Bot 2
    MOV AH, 02h
    MOV DH, 4        ; Fila 5
    MOV DL, 1        ; Columna 1
    INT 10h
    
    MOV AH, 09h
    LEA DX, bot2_name
    INT 21h
    
    ; Dibujar rectángulo para Bot 2 (color amarillo, por ejemplo)
    fill_rectangle 80, 67, 90, 73, 01h  ; Color amarillo
    
    ; Bot 3
    MOV AH, 02h
    MOV DH, 5        ; Fila 6
    MOV DL, 1        ; Columna 1
    INT 10h
    
    MOV AH, 09h
    LEA DX, bot3_name
    INT 21h
    
    ; Dibujar rectángulo para Bot 3 (color magenta, por ejemplo)
    fill_rectangle 80, 83, 90, 89, 05h  ; Color magenta
    
    POP DX
    POP BX
    POP AX
    RET
display_player_names ENDP

; --------------------------------------------------------------------------------
; Procedimiento para convertir un número a cadena
; --------------------------------------------------------------------------------
convert_number_to_string PROC
    ; Entrada: AX = número a convertir
    ; Salida: buffer contiene la cadena resultante
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV BX, 10
    MOV CX, 0        ; Contador de dígitos
    
    ; Si es cero, manejo especial
    CMP AX, 0
    JNE do_convert
    MOV buffer[0], '0'
    MOV buffer[1], '$'
    JMP end_convert
    
do_convert:
    MOV DX, 0
    DIV BX           ; Divide por 10, AX=cociente, DX=residuo
    PUSH DX          ; Guardar dígito
    INC CX           ; Incrementar contador de dígitos
    CMP AX, 0
    JNE do_convert
    
    ; Formar string en buffer
    MOV SI, 0
digit_to_string:
    POP DX
    ADD DL, '0'      ; Convertir a ASCII
    MOV buffer[SI], DL
    INC SI
    LOOP digit_to_string
    
    MOV buffer[SI], '$'  ; Terminar string
    
end_convert:
    POP SI
    POP DX
    POP CX
    POP BX
    RET
convert_number_to_string ENDP

; --------------------------------------------------------------------------------
; Procedimiento para mostrar solo los valores de las vueltas
; --------------------------------------------------------------------------------
display_lap_values PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    
    MOV SI, 0        ; Índice para lapcounter
    
    ; Jugador 1 (fila 1)
    MOV DH, 1
    CALL display_single_lap
    
    ; Jugador 2 (fila 2)
    MOV DH, 2
    CALL display_single_lap
    
    ; Bot 1 (fila 3)
    MOV DH, 3
    CALL display_single_lap
    
    ; Bot 2 (fila 4)
    MOV DH, 4
    CALL display_single_lap
    
    ; Bot 3 (fila 5)
    MOV DH, 5
    CALL display_single_lap
    
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET

; Subrutina interna para mostrar un solo valor de vuelta
display_single_lap:
    PUSH AX
    PUSH BX
    PUSH DX
    
    ; Posicionar cursor
    MOV AH, 02h
    MOV BH, 0
    MOV DL, 12
    INT 10h
    
    ; Convertir número a string
    MOV AX, lapcounter[SI]
    CALL convert_number_to_string
    
    ; Mostrar el número
    MOV AH, 09h
    LEA DX, buffer
    INT 21h
    
    ADD SI, 2        ; Avanzar al siguiente valor
    
    POP DX
    POP BX
    POP AX
    RET
display_lap_values ENDP