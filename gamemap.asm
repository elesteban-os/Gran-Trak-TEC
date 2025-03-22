.model small
.stack 100h

.data
    ; Generacion de mapa del juego con una matriz de bits 
    matrix db 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
           db 1, 0, 1
           db 0, 1, 0
           db 0, 0, 0
    
    rows equ 4
    col equ 3

    ; Variables para la generacion de mapa
    xMap dw 0
    yMap dw 0

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


.code 

getMatrixData:
    ; [Entrada fila y columna con push: primero columna y luego fila]
    ; [Salida en dx: 0 o 1]

    ; Limpiar registros
    xor ax, ax

    ; Cargar byte de la fila en al
    mov al, col

    ; Obtener direccion de la matriz
    mov bx, cx
    mul bx
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
bit0:
    ; Accion cuando el bit es 0
    mov dx, 0
    ret

generateMap:
    mov xMap, 0
    mov yMap, 0
    jmp generateMap_cont

generateMap_cont:  
    mov cx, xMap
    mov dx, yMap
    call getMatrixData

    ; Pintar segun el dato
    cmp dx, 1
    je paintWhiteBox
    
    inc xMap
    jmp generateMap_cont

    ; Verificar si se ha terminado de recorrer la matriz

    ; Si no, llamar a generateMap_cont

paintWhiteBox:
    ; Pintar caja blanca
    pinta_pixel xMap, yMap, 0Fh
    
    ; Incrementar indices
    inc xMap
    jmp generateMap_cont

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