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

.code 
getMatrixData:
    

    ; Cargar byte de la fila en al
    mov al, col
    mul cl
    pop bx
    add ax, bx
    mov bx, ax
    mov al, [matrix + bx]

    ; Hacer AND para obtener el bit deseado
    and al, 1

    inc cx
    push 1
    jmp getMatrixData 


    ; Si es 0, entonces el bit es 0
    jz bit0

    ; Si es 1, entonces el bit es 1
    mov dx, 1

    add cl, 1
    ret
    
bit0:
    ; Accion cuando el bit es 0
    mov dx, 0
    ret

printbit:
    ; Imprimir el bit
    mov ah, 02h
    int 21h
    ret

start:
    mov ax, @data
    mov ds, ax

    ; Indices (se modifican previo a la llamada)
    mov cl, 0 ; Fila
    push 1 ; Columna

    ; Llamada a la funcion
    jmp getMatrixData
    call printbit

    ; Salir del programa
    mov ah, 4Ch
    int 21h

end start