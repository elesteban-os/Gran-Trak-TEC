.model small

include gamedata.asm
include macros.asm
.stack 100h

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

generateMap:
    mov xMap, 0
    mov yMap, 0
    mov xMatrix, 0
    mov yMatrix, 0 
    jmp generateMap_cont

generateMap_newY:
    ; Incrementar yMap
    add yMap, 3
    inc yMatrix
    mov xMap, 0
    mov xMatrix, 0

    ; Verificar si se ha terminado de recorrer la matriz
    cmp yMatrix, rows
    je loopp

    ; Si no, llamar a generateMap_cont para seguir pintando
    jmp generateMap_cont

loopp:
    jmp loopp

generateMap_cont:  
    mov dx, xMatrix
    mov cx, yMatrix
    ;jmp getMatrixData ;;;;
    call getMatrixData

    ; Pintar segun el dato
    cmp dx, 1
    je paintWhiteBox

    cmp dx, 2
    je paintYellowBox

    jmp generateMap_cont1
    
    
   
generateMap_cont1:  
    add xMap, 3
    inc xMatrix

    ; Verificar si llego al final de la fila
    cmp xMatrix, col
    je generateMap_newY

    ; Si no, llamar a generateMap_cont para seguir pintando
    jmp generateMap_cont


paintWhiteBox:
    ; Pintar caja blanca
    mov bx, xMap
    add bx, 3
    mov x2Map, bx

    mov bx, yMap
    add bx, 3
    mov y2Map, bx
    ;draw_rectangle xMap, yMap, x2Map, y2Map, 0Fh
    rellenar_rectangulo xMap, yMap, x2Map, y2Map, 0Fh

    jmp generateMap_cont1

paintYellowBox:
    ; Pintar caja blanca
    mov bx, xMap
    add bx, 3
    mov x2Map, bx

    mov bx, yMap
    add bx, 3
    mov y2Map, bx
    rellenar_rectangulo xMap, yMap, x2Map, y2Map, 0Eh

    jmp generateMap_cont1

ui:
    mov ah, 00h
    mov al, 12h
    int 10h
    ret

start:
    mov ax, @data
    mov ds, ax

    ; Llamada a la funcion
    call ui
    jmp generateMap

    ; Salir del programa
    mov ah, 4Ch
    int 21h

end start