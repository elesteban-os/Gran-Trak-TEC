
; --------------------------------------------------------------------------------
; macros 
; --------------------------------------------------------------------------------

paint_pixel macro x, y, color
    mov ah, 0Ch          ; Función de BIOS para pintar un píxel
    mov al, color       
    mov bh, 00h          
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
        paint_pixel cx, dx, color  
        inc cx
        cmp cx, x2
        jle p_hor_upperLine
        ; Pinta la línea horizontal inferior
        mov cx, x1
        mov dx, y2
    p_hor_bottomLine:
        paint_pixel cx, dx, color
        inc cx
        cmp cx, x2
        jle p_hor_bottomLine
        ; Pinta la línea vertical izquierda
        mov cx, x1
        mov dx, y1
    p_vert_leftLine:
        paint_pixel cx, dx, color
        inc dx
        cmp dx, y2
        jle p_vert_leftLine
        ; Pinta la línea vertical derecha
        mov cx, x2
        mov dx, y1
    p_vert_rightLine:
        paint_pixel cx, dx, color 
        inc dx
        cmp dx, y2
        jle p_vert_rightLine
endm

fill_rectangle macro x1, y1, x2, y2, color 
    LOCAL f_line, f_pixel
        mov dx, y1
    f_line:
        mov cx, x1
    f_pixel:
        paint_pixel cx, dx, color
        inc cx
        cmp cx, x2
        jle f_pixel

        inc dx
        cmp dx, y2
        jle f_line
endm 