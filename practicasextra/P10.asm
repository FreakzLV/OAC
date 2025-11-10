.model tiny

locals

.data
  Mens db "     "
  

.code
    org 100h

;----------Precedimiento principal----------

  principal proc
            mov sp,0fffh
            lea si, Mens
            mov ax, 100
            call printHex
            mov al, 13
            call putchar
            mov ax, 100
            call printDecimal
            mov al, 13
            call putchar
    @@ini0: mov dx, 1
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
    @@inf:
    jmp @@inf
            ret
            endp

;----------Precedimientos----------

  putchar proc
          push ax
          push dx
          mov dl, al
          mov ah, 2
          int 21h
          pop dx
          pop ax
          ret
          endp
          
  printHex proc
           push ax
           push bx
           push cx
           push dx
           push si
           mov dx, ax
           mov bx, 0fh
           mov cl, 12
     .nxt: shr ax,cl
     .msk: and ax,bx
           cmp al, 9
           jbe .menor
           add al,7
    .menor:add al,'0'
           mov byte [si],al
           inc si
           mov ax, dx
           cmp cl, 0
           je .print
           sub cl, 4
           cmp cl, 0
           ja .nxt
           je .msk
   .print: mov cl, 4
           pop si
           push si
  .printy: mov al, byte [si]
           call putchar
           inc si
           loop .printy
           mov al, 10
           call putchar
           pop si
           pop dx
           pop cx
           pop bx
           pop ax
           ret
           endp
   
    printDecimal proc ;  si = cad tempora  ax = num
                 push cx
                 push ax
                 push si
 
                 inc si   ; apuntar al final de tu numero
                 inc si
                 inc si
                 inc si
                 mov cl, 32
                 mov byte [si], cl ; espacio al final
                 dec si
 
             .convert_loop:
                 mov ah, 0    ; limpiar ah
                 mov cl, 10
                 div cl         ; AX / 10 -> residuo en ah
                 add ah, '0'     ; convertir residuo a ASCII
                 mov byte [si], ah   ; guardar el numero en ASCII
                 dec si
                 test al, al
                 jnz .convert_loop  
                 inc si    ; apuntar al primer numero 

        .printd: mov al, byte [si]
                 call putchar
                 inc si
                 cmp al, 32
                 jne .printd
                 mov al, 10
                 call putchar
 
                 pop si
                 pop ax
                 pop cx
                 ret
                 endp
end principal
