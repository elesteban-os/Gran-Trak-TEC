.model small



include gamedata.asm
include macros.asm
include gamemap.asm
include movement.asm


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
    jmp main_loop

end start


