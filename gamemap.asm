.model small

;include gamedata.asm
include macros.asm


.code 

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
    ret

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
    fill_rectangle xMap, yMap, x2Map, y2Map, 0Fh

    jmp generateMap_cont1

paintYellowBox:
    ; Pintar caja blanca
    mov bx, xMap
    add bx, 3
    mov x2Map, bx

    mov bx, yMap
    add bx, 3
    mov y2Map, bx
    fill_rectangle xMap, yMap, x2Map, y2Map, 0Eh

    jmp generateMap_cont1


