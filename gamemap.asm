.model small
.stack 100h

.data
    ; Generacion de mapa del juego con una matriz de bits 
    matrix db 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1
           db 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1
           db 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1
           db 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1
    
    rows equ 4
    col equ 11

    ; Variables para la generacion de mapa
    xMap dw 0
    yMap dw 0
    x2Map dw 0
    y2Map dw 0
    xMatrix dw 0
    yMatrix dw 0    

; Macros para pintar un pixel en la pantalla
pinta_pixel macro x, y, color
    mov ah, 0Ch          ; Función de BIOS para pintar un píxel
    mov al, color       
    mov bh, 00h          ; Página de pantalla (0)
    mov cx, x           
    mov dx, y            
    int 10h              
endm

; Macro para pintar un rectangulo en la pantalla
draw_rectangle macro x1, y1, x2, y2, color 
    LOCAL p_hor_upperLine, p_hor_bottomLine, p_vert_leftLine, p_vert_rightLine
        ; Pinta la línea horizontal superior
        mov cx, x1
        mov dx, y1
    p_hor_upperLine:
        pinta_pixel cx, dx, color  
        inc cx
        cmp cx, x2
        jle p_hor_upperLine
        ; Pinta la línea horizontal inferior
        mov cx, x1
        mov dx, y2
    p_hor_bottomLine:
        pinta_pixel cx, dx, color
        inc cx
        cmp cx, x2
        jle p_hor_bottomLine
        ; Pinta la línea vertical izquierda
        mov cx, x1
        mov dx, y1
    p_vert_leftLine:
        pinta_pixel cx, dx, color
        inc dx
        cmp dx, y2
        jle p_vert_leftLine
        ; Pinta la línea vertical derecha
        mov cx, x2
        mov dx, y1
    p_vert_rightLine:
        pinta_pixel cx, dx, color 
        inc dx
        cmp dx, y2
        jle p_vert_rightLine
endm

rellenar_rectangulo macro x1, y1, x2, y2, color 
        LOCAL f_line, f_pixel
        mov dx, y1
    f_line:
        mov cx, x1
    f_pixel:
        pinta_pixel cx, dx, color
        inc cx
        cmp cx, x2
        jle f_pixel

        inc dx
        cmp dx, y2
        jle f_line
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
    mov bl, cl
    mul bl
    mov bx, dx
    add ax, bx
    mov bx, ax

    ; Obtener el bit de la matriz
    mov al, [matrix + bx]

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
    rellenar_rectangulo xMap, yMap, x2Map, y2Map, 0Fh

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