.model small

include gamedata.asm 
include macros.asm
include gamemap.asm
include movement.asm
include timer.asm
include screen.asm

.code
; --------------------------------------------------------------------------------
; inicialización de lo necesario para iniciar el programa
; --------------------------------------------------------------------------------
start:
    mov ax, @data
    mov ds, ax

    ; Mostrar pantalla de inicio
    call clear_screen
    call show_start_screen
    
    ; Esperar tecla 'X' para iniciar
    call wait_for_start
    call clear_screen

    ; Establecer el modo gráfico
    mov ah, 00h           ; Función 00h: Establecer modo de video o "modo gráfico"
    mov al, 12h           ; Modo gráfico 12h: 640x480, 16 colores
    int 10h               ; Llamada a la interrupción para establecer el modo gráfico

    ; Inicializar el temporizador
    call init_timer
    
    ; Generar el mapa y empezar el juego
    call generateMap
    jmp main_loop

end start


