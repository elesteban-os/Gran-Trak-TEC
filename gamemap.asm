.model small
.stack 100h

.data
    ; Generacion de mapa del juego con una matriz de bits 
    matrix db 1, 1, 1
           db 1, 0, 1
           db 0, 1, 0
           db 0, 0, 0
    
    rows equ 4
    col equ 3

; Macros para pintar un pixel en la pantalla
pinta_pixel macro x, y, color
    mov ah, 0Ch          ; Función de BIOS para pintar un píxel
    mov al, color       
    mov bh, 00h          ; Página de pantalla (0)
    mov cx, x           
    mov dx, y            
    int 10h              
endm

.code 

getMatrixData:
    ; [Entrada fila y columna con push: primero columna y luego fila]
    ; [Salida en dx: 0 o 1]

    ; Limpiar registros
    xor ax, ax

    ; Cargar byte de la fila en al
    mov al, col

    ; Obtener direccion de la matriz
    pop cx
    mul cl
    pop bx
    add ax, bx
    mov bx, ax

    ; Obtener el bit de la matriz
    mov al, [matrix + bx]

    ; Hacer AND para obtener el bit deseado
    and al, 1

    
    push 1 ; Columna
    push 1 ; Fila
    jmp getMatrixData 

    ; Si es 0, entonces el bit es 0
    jz bit0

    ; Si es 1, entonces el bit es 1
    mov dx, 1
    ret
    
bit0:
    ; Accion cuando el bit es 0
    mov dx, 0
    ret

generateMap:
    

ui:
    mov ah, 00h
    mov al, 12h
    int 10h
    ret

start:
    mov ax, @data
    mov ds, ax

    ; Indices (se modifican previo a la llamada)
    push 1 ; Columna
    push 0 ; Fila
    

    ; Llamada a la funcion
    call ui
    pinta_pixel 1, 1, 0Ah
    jmp getMatrixData
    call printbit

    ; Salir del programa
    mov ah, 4Ch
    int 21h

end start