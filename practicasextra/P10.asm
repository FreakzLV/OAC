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
    
    mov ax, 14207d
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

; Subrutina printHex (adaptado a 16bits y cambio ya que no se necesita guardar ahora)
printHex proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 4     ; 4 porque 16bits son 4 digitos hexadecimales
@@ciclo:
    rol ax, 4     ; Rotar 4 bits a la izquierda
    push ax       ; Guardar AX
    
    and al, 0Fh   ; Quedarnos con los 4 bits bajos de al
    cmp al, 9
    jbe @@siesdigito
    add al, 7     ; Esto para hacerlo letra si se pasa de 9 (A-F)
    
@@siesdigito:
    add al, '0'
    
    mov dl, al
    call putchar ; Imprimir con el putchar
    
    pop ax       ; Recuperar AX
    loop @@ciclo
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

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