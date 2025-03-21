.model small

.data
    ; Generacion de mapa del juego con una matriz de bits 
    matrix db 00110011b,
              00111000b,
              11001100b,
              10101010b
    
    rows equ 4
    col equ 8

.bss
    ; Para obtener un dato de la matriz
    matrixResult resb 1

.code 
getMatrixData:
    ; Indices (se modifican previo a la llamada)
    mov esi, 2 ; Fila
    mov edi, 3 ; Columna

    ; Cargar byte de la fila en al
    mov al, [matrix + esi]
    
    ; Crear mascara para obtener el bit deseado
    mov bl, 1
    shl bl, edi

    ; Hacer AND para obtener el bit deseado
    and al, bl

    ; Si es 0, entonces el bit es 0
    jz bit0

    ; Si es 1, entonces el bit es 1
    mov [matrixResult], 1
    ret
    
bit0:
    ; Accion cuando el bit es 0
    mov [matrixResult], 0
    ret


section .text
    global _start

start:
    ; Llamada a la funcion
    jz getMatrixData

    ; Salir del programa
    mov ah, 4Ch
    int 21h

end start