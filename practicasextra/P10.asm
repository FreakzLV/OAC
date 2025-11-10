.model tiny

.data

.code 
    org 100h 

;****************************************************
;   Procedimiento Principal
;****************************************************

principal proc
;PrintHex y PrintDec
    mov sp, 0fffh     ;inicializar SP(Stack Pointer)
    call salto
    
    mov ax, 0abcdh
    call printHex
    call salto
    
    mov ax, 1234h
    call printDec
    call salto

;Listado 1
@@ini0: 
    mov dx, 1
@@ini1: mov cx, dx
@@sigue: mov al, 'x'
    call putchar
    loop @@sigue
    mov al, 10
    call putchar
    mov al, 13
    call putchar
    inc dx
    cmp dx, 20
    jbe @@ini1
    @@final:
    jmp @@final
   
    ret
endp

;****************************************************
;   Procedimientos
;****************************************************   

; Subrutina salto - Mejor presentacion
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

; Subrutina putchar (la del ejemplo) - Sirve ademas para los prints hex y dec
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

; Subrutina printHex
printHex proc
    push ax
    mov dx, ax
    mov cl, 4
    mov bl, 0fh
@@siguiente:
    rol ax, cl
    and ax, bx
    cmp al, 10
    jl @@sumar
    add al, 7
@@sumar: 
    add al, '0'
    call putchar
    mov ax, dx
    add cl, 4
    cmp cl, 16
    ja @@salir
    jmp @@siguiente
@@salir:
    pop ax
    ret

; Subrutina printDec (como el de la practica 1 extra pero adaptado)
printDec proc
    push ax
    push bx
    push cx
    push dx
    mov cx, 0
    mov bx, 10
@@conversion:
    mov dx, 0 ;limpiar dx para la division
    div bx    ; ax = ax/10, dx = ax%10
    push dx
    
    inc cx
    test ax, ax
    jnz @@conversion
@@imp:
    pop dx
    add dl, '0'
    mov al, dl ;Para imprimirlo con el putchar
    call putchar
    loop @@imp ;Para imprimir todos
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp
end principal