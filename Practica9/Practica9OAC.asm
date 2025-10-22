%include "./pc_io.inc"

section .text
global _start

_start:
    ; ---- ROTACION A LA IZQUIERDA CON CARRY----
    mov edx, msg
    call puts
    call salto
    
    ; Mostrar cadena binaria inicial
    mov edx, msg_inicial
    call puts
    mov edx, cadena_bits
    call imprimir_cadena_8bits
    
    call salto
    mov edx, msg_rot
    call puts
    
    call capturar_rotaciones
    
    call salto
    
    ; Aplicar rotaciones
    mov edx, cadena_bits
    call rotacion_izquierda_acarreo
    
    ; Mostrar cadena despues de corrimientos
    mov edx, msg_despues
    call puts
    mov edx, cadena_bits
    call imprimir_cadena_8bits
    
    call salto
    
    ; Convertir a valor numerico
    mov edx, cadena_bits
    call convertir_8bits_a_valor
    
    mov edx, msg_resultado
    call puts
    
    mov esi, buffer_hex
    call printHex

    call salto

    ; Salir
    mov eax, 1
    mov ebx, 0
    int 80h

; ===== Subrutinas para captura e impresion =====

imprimir_cadena_8bits:
    push eax
    push edx
    push esi
    mov esi, 0
    
.loop:
    cmp esi, 8
    je .fin
    
    mov al, [edx + esi]
    call putchar
    
    inc esi
    jmp .loop
    
.fin:
    pop esi
    pop edx
    pop eax
    ret

; Capturar numero de rotaciones
capturar_rotaciones:
    call getche
    sub al, '0'
    mov [num_rotacion], al
    ret

convertir_8bits_a_valor:
    push ebx
    push ecx
    push edx
    push esi
    
    mov eax, 0  ; resultado acumulado
    mov esi, 0
    
.loop:
    cmp esi, 8
    je .fin
    
    ; Leer bit
    mov cl, [edx + esi]
    sub cl, '0'
    
    ; Si el bit es 0, no sumar nada
    cmp cl, 0
    je .siguiente
    
    ; Si el bit es 1, usar XLAT para obtener el peso
    push eax
    push esi
    mov ebx, tabla_pesos_rotacion  ; cargar direccion de la tabla
    mov eax, esi                    ; eax como indice
    xlat
    movzx eax, al                   ; extender AL a EAX
    mov ebx, eax                    ; guardar peso en EBX temporalmente
    pop esi
    pop eax
    
    ; Sumar el peso al resultado
    add eax, ebx

.siguiente:
    inc esi
    jmp .loop

.fin:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

;---- Subrutina para rotacion a la izquierda con carry ----
rotacion_izquierda_acarreo:
    pushad

    mov ah, 1  ; Ponemos la CF en 1 pa*ra debuggear y verificar que el comportamiento de la subrutina sea el correcto
    sahf 
    
    ; Se obtiene lo que tenia CF antes de siquiera iterar ya que se necesitara
    lahf
    and ah, 1  ; Aislamos el bit 0 dejando todos los demas en 0s
    add ah, '0' ; Pasar de valor numerico a caracter ya que nosotros tenemos una CADENA binaria
    mov[acarreo], ah ; Pasamos el valor de la CF a un espacio de memoria auxiliar

    ;Se asigna a CL la cantidad de rotaciones
    mov bl, [num_rotacion]
    mov cl, bl

; Loop principal donde se realizara la rotacion de bits con ayuda de CF
.loop_rotaciones:
    cmp cl, 0 ; Si CL llega a 0 entonces ya terminamos de rotar la cadena
    je .fin

    mov bl, [edx+0
    
    ] ; Lo que tenemos en el MSB se pasa a BL para trabajar con el mas adelante

    ; Nuestros indices para mover los bits
    mov edi, 1
    mov esi, 0

; Loop en el cual se mueven todos los bits de la cadena
.mover_bits:
    cmp edi, 8 ; Si EDI llega a 8 ya terminamos de mover todos los bits de la cadena
    je .colocar_bit

    ; Movimiento de los bits acorde a RCL
    mov al, [edx+edi] 
    mov[edx+esi], al

    ; Incrementamos nuestros indices para movernos
    inc edi
    inc esi

    ; Continuamos el ciclo
    jmp .mover_bits

; Loop para colocar el ultimo bit (el que tenia el acarreo)
.colocar_bit:
    ; Lo que teniamos en nuestro espacio de memoria (el acarreo anterior) se pasa a AL
    mov al, [acarreo]
    mov [edx+7], al ; Se coloca lo que hay en AL en el LSB de la cadena

    ; Movimiento del MSB a CF
    sub bl, '0' ; BL tenia lo del MSB antes de pasarlo a CF se convierte a numerico
    mov ah, bl
    sahf

    ; Volvemos a obtener lo que tenia CF 
    lahf
    and ah, 1  ; Aislamos el bit 0 dejando todos los demas en 0s
    add ah, '0' ; Pasar de valor numerico a caracter ya que nosotros tenemos una CADENA binaria
    mov[acarreo], ah ; Pasamos el valor de la CF a un espacio de memoria auxiliar

    ; Decrementamos el numero de rotaciones faltantes y continuamos con el ciclo principal
    dec cl
    jmp .loop_rotaciones

; Salimos de la subrutina
.fin:
    popad
    ret

; Salto de linea
salto:
    push eax
    mov al, 13
    call putchar
    mov al, 10
    call putchar
    pop eax
    ret

; Imprimir en hexadecimal
printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    mov edi, 0

.nxt: 
    shr eax, cl

.msk: 
    and eax, ebx
    cmp al, 9
    jbe .menor
    add al, 7

.menor:
    add al, '0'
    mov byte [esi + edi], al
    inc edi
    mov eax, edx
    cmp cl, 0
    je .print
    sub cl, 4
    cmp cl, 0
    ja .nxt
    je .msk

.print: 
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret

section .data

    msg db "===== Rotacion a la izquierda con acarreo  =====", 0
    msg_inicial db "Cadena binaria inicial: ", 0
    msg_rot db "Ingrese numero para la rotacion: ", 0
    msg_despues db "Binario despues de rotacion: ", 0
    msg_resultado db "Valor en hexadecimal: ", 0


    tabla_pesos db 8, 4, 2, 1
    tabla_pesos_rotacion db 128, 64, 32, 16, 8, 4, 2, 1

    cadena_bits db '00000000'  ; Cadena binaria de 8 bits predefinida en memoria (osea que no se captura se cambia desde aqui)

section .bss
    num_rotacion resb 1
    buffer_hex resb 10
        acarreo resb 1