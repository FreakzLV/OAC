.model tiny
locals
    
 .code
    org 100h
    
principal proc
        mov sp,0fffh        ;Inicializar SP(Stack Pointer)
        mov dx, 43h
        mov al, 80h
        call outportb

;Punto 2
        mov ax, 4h
        mov cl, 3
        
        call setBit
        call printBin 
        call salto
        
        mov cl, 2
        call clearBit
        call printBin
        call salto
        
        mov cl, 0
        call notBit
        call printBin
        call salto
        
;Punto 3
        ;Ejemplo
        mov dx, 42h
        mov al, 4ch
        call outportb
        call printBin
        call salto

        /*
        ;SetBitPort
        mov dx, 42h
        mov cl, 4
        call setBitPort
        call printBin
        call salto
        
        ;ClearBitPort
        mov dx, 42h
        mov cl, 3
        call clearBitPort
        call printBin
        call salto
        
        ;NotBitPort
        mov dx, 42h
        mov cl, 7
        call notBitPort
        call printBin
        call salto
        */
.inf:
    jmp .inf
    ret
    endp
    
;****************************************************
;   Procedimientos
;****************************************************  
outportb proc
    ;en dx recibe el puerto
    ;en al el dato a sacar
    out dx, al
    ret
endp

; Subrutina salto
salto proc
    push ax
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    pop ax
    ret
endp

    
; Subrutina putchar (la del ejemplo de la Practica Extra 1) 
putchar proc
    push ax
    push dx
    mov dl, al
    mov ah, 2  ; imprimir caracter DL
    int 21h    ; usando servicio 2 (ah = 2)
    pop dx     ; del int 21h
    pop ax
    ret
endp

;Subrutina para activar un bit
setBit proc
    push cx
    mov bx, 1
    rol bx, cl
    or ax, bx
    pop cx
    ret
endp

;Subrutina para hacer clear a un bit
clearBit proc
    push cx
    mov bx, 1
    rol bx, cl
    not bx
    and ax, bx
    pop cx
    ret
endp

;Subrutina para invertir un bit
notBit proc
    push cx
    mov bx, 1
    rol bx, cl
    xor ax, bx
    pop cx
    ret
endp

;Subrutina para activar un bit (led) en un puerto
setBitPort proc
    in al, dx
    call setBit
    out dx, al
    ret
endp

;Subrutina para activar un bit (led) en un puerto
clearBitPort proc
    in al, dx
    call clearBit
    out dx, al
    ret
endp

;Subrutina para invertir un bit (led) en un puerto
notBitPort proc
    in al, dx
    call notBit
    out dx, al
    ret
endp

; Subrutina para imprimir en binario (8bits)
printBin proc
    push ax
    push cx
    
    mov cx, 8       ; 8 bits a imprimir
    mov ah, al
@@ciclo:
    shl ah, 1       ; El MSB va a Carry
    jc @@uno        ; Si Carry = 1, imprimir '1'
    mov al, '0'     ; Si Carry = 0, imprimir '0'
    jmp @@print
@@uno:
    mov al, '1'
@@print:
    call putchar
    loop @@ciclo
    
    pop cx
    pop ax
    ret
endp
    
end principal