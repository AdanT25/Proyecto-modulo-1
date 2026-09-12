; ===================================================================
; PROYECTO MÓDULO 1: VISOR DE MEMORIA
; Lenguajes de Interfaz (SCC-1014)
; Alumno: Braulio Adan Torres Enriquez
; Descripción: Recorre un arreglo de 10 elementos de 64 bits y muestra 
;              su dirección de memoria y su valor en hexadecimal.
; ===================================================================

extrn GetStdHandle : proc
extrn WriteConsoleA : proc
extrn ExitProcess   : proc

.data
    ; 1. Arreglo de 10 elementos (64 bits cada uno)
    arreglo     DQ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50

    ; Cadenas de texto para formatear la salida
    lbl_dir     DB 'Direccion: ', 0
    lbl_val     DB ' Valor: ', 0
    newline     DB 13, 10, 0
    
    ; Tabla de conversión a hexadecimal (Mayúsculas estrictas)
    hex_chars   DB '0123456789ABCDEF'
    
    ; Buffers y variables auxiliares
    buffer_hex  DB 17 DUP (0)   ; Buffer para 16 dígitos hex + nulo
    hConsole    DQ 0            ; Handle de salida de la consola
    escritos    DQ 0            ; Bytes escritos por WriteConsoleA

.code

; -------------------------------------------------------------------
; Función: print_hex_qword
; Convierte un valor de 64 bits a 16 dígitos hexadecimales y lo imprime
; Entrada: RAX = Valor numérico de 64 bits a convertir
; -------------------------------------------------------------------
print_hex_qword proc
    push rbx
    push rcx
    push rdx
    push rdi

    lea rdi, buffer_hex
    mov rcx, 16
    add rdi, 15                  ; Apuntar al final del buffer (16 dígitos)
    mov rbx, 0Fh                 ; Máscara para los 4 bits menos significativos

hex_loop:
    mov rdx, rax
    and rdx, rbx                 ; Extraer 4 bits
    movzx rdx, byte ptr [hex_chars + rdx]
    mov [rdi], dl                ; Guardar carácter ASCII
    dec rdi                      ; Moverse a la izquierda
    shr rax, 4                   ; Desplazar 4 bits a la derecha
    loop hex_loop

    ; Asegurar terminación nula
    mov byte ptr [buffer_hex + 16], 0

    ; Imprimir los 16 dígitos generados
    lea rdi, buffer_hex
    call print_string

    pop rdi
    pop rdx
    pop rcx
    pop rbx
    ret
print_hex_qword endp

; -------------------------------------------------------------------
; Función: print_string
; Imprime una cadena terminada en 0 en la consola usando WriteConsoleA
; Entrada: RDI = Puntero a la cadena terminada en 0
; -------------------------------------------------------------------
print_string proc
    push rcx
    push rdx
    push r8
    push r9
    push rsi

    mov rsi, rdi                 ; Guardar puntero original

    ; 1. Calcular longitud de la cadena
    mov rcx, -1
    xor al, al
    repne scasb
    not rcx
    dec rcx                      ; RCX = Longitud sin incluir el 0

    ; 2. Imprimir con WriteConsoleA
    mov rdx, rsi                 ; RDX = Puntero al mensaje
    mov r8, rcx                  ; R8 = Longitud
    mov rcx, [hConsole]          ; RCX = Handle de consola
    lea r9, escritos             ; R9 = Bytes escritos
    mov qword ptr [rsp + 20h], 0 ; lpReserved = NULL (5to parámetro)
    call WriteConsoleA

    pop rsi
    pop r9
    pop r8
    pop rdx
    pop rcx
    ret
print_string endp

; -------------------------------------------------------------------
; Función Principal: main
; -------------------------------------------------------------------
main proc
    sub rsp, 28h                 ; Shadow space + alineación de pila

    ; Obtener Handle de Salida de Consola (STD_OUTPUT_HANDLE = -11)
    mov rcx, -11
    call GetStdHandle
    mov [hConsole], rax

    ; Inicializar punteros para el recorrido
    lea rbx, arreglo             ; RBX = Puntero al inicio del arreglo
    mov rsi, 10                  ; RSI = Contador de iteraciones (10 elementos)

bucle_visor:
    ; A) Imprimir etiqueta "Direccion: "
    lea rdi, lbl_dir
    call print_string

    ; B) Imprimir Dirección de Memoria actual (RBX) en Hexadecimal
    mov rax, rbx
    call print_hex_qword

    ; C) Imprimir etiqueta " Valor: "
    lea rdi, lbl_val
    call print_string

    ; D) Imprimir el Valor contenido en [RBX] en Hexadecimal
    mov rax, [rbx]
    call print_hex_qword

    ; E) Imprimir Salto de Línea
    lea rdi, newline
    call print_string

    ; F) Avanzar al siguiente elemento (8 bytes) y decrementar contador
    add rbx, 8
    dec rsi
    jnz bucle_visor

    ; Terminar de manera limpia según especificación RT1
    xor eax, eax
    add rsp, 28h
    ret
main endp

end