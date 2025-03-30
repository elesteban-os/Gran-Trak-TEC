
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

getMatrixData_macro macro row1, col1
    xor ax, ax          ; Limpiar registros
    mov al, rows         

    mov bx, row1        
    mul bl            
    mov bx, col1        
    add ax, bx         
    mov bx, ax        

    xor ax, ax        
    mov al, [matrix + bx] 

    mov dx, ax         ; Guardar resultado en DX
endm


collision1 macro JX, JY, PLAYER
    LOCAL resetPlayer1_, resetPlayer2_, resetPlayer_, collisionDet1, end_collision
    jmp collisionDet1
    
    ; Para detectar colisiones contra la pared
    resetPlayer1_:  
        mov J1_x1, 260
        mov J1_x2, 270
        mov J1_y1, 400
        mov J1_y2, 410
        mov [lapcheckpoint], 0
        jmp end_collision

    resetPlayer2_:  
        mov J2_x1, 260
        mov J2_x2, 270
        mov J2_y1, 400
        mov J2_y2, 410
        mov [lapcheckpoint + 2], 0
        jmp end_collision
        
    resetPlayer_:
        mov bx, PLAYER 
        cmp bx, 1
        je resetPlayer1_

        cmp bx, 2
        je resetPlayer2_
        jmp end_collision

    collisionDet1:
        mov ah, 0Dh
        mov bh, 0
        mov cx, JX
        mov dx, JY
        int 10h

        cmp al, 0Fh
        je resetPlayer_    

    end_collision:
        mov dx, 1
endm


lapDetection macro JX, JY, PLAYER
    LOCAL lapAdder, lapAnalize, CheckpointSub, lapCheckpointAdd, lapCheckpointAdd1, lapDetY, lapDet, lapCounter1, end_collision1, lapCheckpoint0
    jmp lapDet
    
    lapAdder: 
        ; Añadir checkpoint (comprobar cual fue el jugador)
        mov ax, 0
        mov [lapcheckpoint], ax

        mov ax, [lapcounter]
        inc ax
        mov [lapcounter], ax

        mov lapX, 100
        mov lapY, ax
        paint_pixel lapX, lapY, 03h
        jmp end_collision1

    lapAnalize:
       mov ax, [lapcheckpoint]
       cmp ax, 1
       je lapAdder

       cmp ax, -1
       je lapCheckpointAdd1

       cmp ax, 0
       je CheckpointSub

       jmp end_collision1

    CheckpointSub:
        ; Restar checkpoint (comprobar cual fue el jugador)
        mov ax, lapcheckpoint
        sub ax, 3
        mov lapcheckpoint, ax

        jmp end_collision1

    lapCheckpointAdd: ;;; verificar func
        ; Incrementar checkpoint (comprobar cual fue el jugador)
        mov ax, lapcheckpoint
        cmp ax, 0
        je lapCheckpointAdd1

        jmp end_collision1

    lapCheckpointAdd1:
        mov ax, lapcheckpoint
        inc ax
        mov lapcheckpoint, ax

        jmp end_collision1

    lapCheckpoint0:
        mov ax, lapcheckpoint
        inc ax
        mov lapcheckpoint, ax

        jmp end_collision1

    lapCounter1:
        mov bx, LAPPIXEL
        cmp bx, 2
        je lapAnalize

        cmp bx, 1
        je lapCheckpointAdd1

        jmp end_collision1

    lapDetY:
        cmp dx, 375
        ja lapCounter1
        jmp end_collision1

    lapDet:
        mov cx, JX
        mov dx, JY
        ; Detectar posX
        cmp cx, 316
        je lapDetY     
        jmp end_collision1

    end_collision1:
        mov dx, 1

endm

lapDetection1 macro JX, JY, PLAYER

    lapCounter1:
        mov bx, LAPPIXEL
        cmp bx, 2
        je lapAnalize

        cmp bx, 1
        je lapCheckpointAdd1

        jmp end_collision1

    lapDetY:
        cmp dx, 375
        ja lapCounter1
        jmp end_collision1

    lapDet:
        mov cx, JX
        mov dx, JY
        ; Detectar posX
        cmp cx, 316
        je lapDetY     
        jmp end_collision1

    end_collision1:
        mov dx, 1

endm