
.code
getMatrixData:
    ; [Entrada fila y columna con push: primero columna y luego fila]
    ; [Salida en dx: 0 o 1]

    ; Limpiar registros
    xor ax, ax

    ; Cargar byte de la fila en al
    mov al, col

    ; Obtener direccion de la matriz
    mov bl, cl
    mul bl
    mov bx, dx
    add ax, bx
    mov bx, ax

    ; Obtener dato de la matriz
    xor ax, ax
    mov al, [matrix + bx]

    mov dx, ax
    ret
    ;----------------------------

    ; Hacer AND para obtener el bit deseado
    and al, 1

    ; Si es 0, entonces el bit es 0
    jz bit0

    ; Si es 1, entonces el bit es 1
    mov dx, 1
    
    ret
    ;jmp generateMap_cont ;;;
bit0:
    ; Accion cuando el bit es 0
    mov dx, 0
    ret

