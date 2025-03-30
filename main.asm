.model small


include matrixm.asm
include gamedata.asm
include macros.asm
include gamemap.asm
include movement.asm
;include laps.asm


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

    call generateMap
    mov Jx, 316
    mov Jx1, 317
    mov Jy, 376
    mov Jy1, 443

    fill_rectangle Jx, Jy, Jx1, Jy1, 08h
    jmp main_loop

    

end start


