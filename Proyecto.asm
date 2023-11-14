.MODEL SMALL
.STACK 100h
.DATA
    ENDCDE DB 00 
    HANDLE DW ?
    Caracter DB ?
    ROW DB 00
    Mensaje_Menu DB "Bienvenido al Menu", 10, 13, "$"
    Mensaje_Seleccion DB "Digite el numero para seleccionar una opcion", 10, 13, "$"
    Mensaje_Establecer DB "1-Establecer nivel y nombre del jugador", 10, 13, "$"
    Mensaje_Nombre DB "Al finalizar precione enter", 10,13,"Ingrese su nombre (Con un maximo de 20 caracteres)", 10, 13, "$"
    Mensaje_Nivel DB 10, 13, "Ingrese el nivel de dificultad", 10,13 ,"(Con un maximo de 2 caracteres, solo se tomara en cuenta numeros)", 10, 13, "$"
    Mensaje_Escenario DB "2-Seleccione el escenario", 10, 13, "$"
    Mensaje_Iniciar DB "3-Iniciar juego", 10, 13, "$"
    Mensaje_Acerca DB "4-Acerca de", 10, 13, "$"
    Mensaje_Fin DB "5-Salir", 10, 13, "$"
    Nombre DB 20 dup('$')
    Nivel DB 3 dup('$')
    Archivo_Acerca DB "Acerca.txt", 0
    Print_Nombre DB "Nombre del Jugador: ", 10, 13, "$"
    Print_Nivel DB 10, 13,"Nivel de dificultad: ", 10, 13, "$"
    Print_Nivel_Actual DB 3 dup("$")
    suma DB 3 DUP('$')
    ;;;;;
    cuadro_Personaje DB 219
    filaLimiteMin DB 10
    filaLimiteMax DB 14
    fila DB 12
    columna DB 20
    counter DB 10
    sumar DB 10
    posicion macro x, y 
        mov ah, 02h
        mov bh, 00h
        mov dh, x
        mov dl, y
        int 10h
        endm
    Escribir macro caracter, cantidad
        mov ah, 09h
        mov al, caracter
        mov bl, 00h
        mov cx, cantidad
        int 10h
        endm
    fila2 db 12
    columna2 db 40
    columnaMin2 db 25
    columnaMax2 db 54
    final_loop dw 250
    contador_loop dw 0
    Nivel_actual dw 1
    table_Nivel DW 0, 14, 30, 40, 55, 70, 85, 100, 115, 130, 145, 165, 180, 200, 230

.CODE
MOV AX, @DATA
MOV DS, AX 
Inicio:
    ;mov [Nivel_actual], 1
    CALL Limpia
    CALL Colocar_Cursor
    CALL Mostrar_Inicio
    CALL Seleccion
    JMP Inicio
Mostrar_Inicio PROC NEAR
    mov AH, 09h 
	lea dx, Mensaje_Menu
	int 21h
    mov AH, 09h
    lea dx, Mensaje_Seleccion
    int 21h
    mov AH, 09h
    lea dx, Mensaje_Establecer
    int 21h
    mov AH, 09h
    lea dx, Mensaje_Escenario
    int 21h
    mov AH, 09h
    lea dx, Mensaje_Iniciar
    int 21h
    mov AH, 09h
    lea dx, Mensaje_Acerca
    int 21h
    mov AH, 09h
    lea dx, Mensaje_Fin
    int 21h
    RET
    Mostrar_Inicio ENDP

Seleccion PROC NEAR
    mov ah, 01h
    int 21h
    cmp al, '1'
    je Salto_Establecer
    cmp al, '2'
    je Salto_Escenario
    cmp al, '3'
    je Salto_Iniciar
    cmp al, '4'
    je Salto_Acerca
    cmp al, '5'
    je Salto_Fin
    RET

    Salto_Establecer:
    CALL Establecer
    RET
    Salto_Escenario:
    CALL Escenario
    RET
    Salto_Iniciar:
    CALL Iniciar
    RET
    Salto_Acerca:
    CALL Acerca
    RET
    Salto_Fin:
    CALL Fin
    RET
    Seleccion ENDP
Establecer PROC NEAR
    CALL limpiar_datos
    CALL Limpia
    CALL Colocar_Cursor

    mov ah, 09h
    lea dx, Mensaje_Nombre
    int 21h
    mov si,00h
    Guardar:
        mov ax,0000
        mov ah,01h
        int 21h
        cmp al,0dh 
        je Seguir2
        mov Nombre[si],al
        inc si  
        jmp Guardar
    Seguir2:
    

     mov ah, 09h
    lea dx, Mensaje_Nivel
    int 21h
    mov si,00h
    Guardar2:
        mov ax,0000
        mov ah,01h
        int 21h
        cmp al,0dh 
        je Seguir3
        cmp al, '0'
        jl  Guardar2           
        cmp al, '9'
        jg  Guardar2
        mov Nivel[si],al
        inc si  
        cmp si, 3
        je Seguir3
        jmp Guardar2
    Seguir3:

    ConvertirCadenaANumero:
    xor si, si
    mov si, offset [Nivel]     ; Puntero a la cadena
    mov cx, 10         ; Inicializa el factor de multiplicación
    xor ax, ax         ; Inicializa el acumulador

    convertir_loop:
    mov bl, [si]       ; Carga el siguiente carácter de la cadena
    cmp bl, '$'        ; Comprueba si es el final de la cadena
    je  convertir_fin

    sub bl, '0'         ; Convierte el carácter a valor numérico
    mul cx             ; Multiplica el acumulador por 10
    add ax, bx     ; Suma el valor numérico al acumulador

    inc si             ; Avanza al siguiente carácter
    jmp convertir_loop

    convertir_fin:
        cmp ax, 1
        jl Nivel_Menor
        cmp ax, 15
        jg Nivel_Mayor
        mov [Nivel_actual], ax  ; Almacena el valor numérico en Nivel_actual
        ret
    Nivel_Menor:
        mov ax, 1
        mov [Nivel_actual], ax
        ret
    Nivel_Mayor:
        mov ax, 15
        mov [Nivel_actual], ax
        ret

    limpiar_datos PROC NEAR
    ; Código para limpiar (inicializar) la variable
    mov si, 00h  ; Puntero a la variable        
    mov cx, 3          ; Número de bytes en la variable 
    limpiar_loop:
    mov Nivel[si], '$'      ; Asigna el valor '$' al byte actual
    inc si 
    loop limpiar_loop   

    mov si, 00h  ; Puntero a la variable
    mov cx, 20          ; Número de bytes en la variable
    limpiar_loop2:
    mov Nombre[si], '$'      ; Asigna el valor '$' al byte actual
    inc si 
    loop limpiar_loop2
    
     xor bx, bx
    RET

    limpiar_datos ENDP
    Establecer ENDP


Escenario PROC NEAR
    
    RET
    Escenario ENDP
Iniciar PROC NEAR
    CALL Actualizar_Nivel
    ciclo:
    CALL Mostrar_Datos
    CALL Dibujar_Cuadro
    dec columna2
    call Mostrar_Obstaculo
    call Mostrar_Avatar
    call Bucle_Delay
   mov ah, 01h
   int 16h
   ; Se preciona una tecla?
   jz sin_tecla_presionada
    ; Si se preciona una tecla, entonces se lee el codigo de la tecla
   mov ah, 00h
   int 16h
   ; Mover el cuadro segun las teclas
   cmp al, 'w'
   je mover_arriba
   cmp al, 's'
   je mover_abajo
      cmp ah, 'H'
   je mover_arriba
   cmp ah, 'P'
   je mover_abajo
   cmp al, 'e'
   je salir_Iniciar
   cmp al, 'p'
   je pausa_Llamar
   cmp al, 'n'
   je subir_nivel
   sin_tecla_presionada:
   jmp ciclo

    pausa_Llamar:
        call pausa
        jmp ciclo
    subir_nivel:
        mov ax, [Nivel_actual]
        cmp al, 15
        je ciclo
        inc al
        mov Nivel_actual, ax
        call Actualizar_Nivel
        jmp ciclo
    mover_arriba:
        dec fila
        mov al, filaLimiteMin
        cmp fila, al
        jl fila_Limite_Min
        JMP ciclo
    mover_abajo:
        inc fila
        mov al, filaLimiteMax
        cmp fila, al
        jge fila_Limite_Max
        JMP ciclo
    fila_Limite_Min:
        mov al, filaLimiteMin
        mov fila,al
        JMP ciclo
    fila_Limite_Max:
        mov al, filaLimiteMax
        mov fila,al
        JMP ciclo

    pausa proc near
        CALL Limpia
        CALL Dibujar_Cuadro
        call Mostrar_Obstaculo
        call Mostrar_Avatar
            mov ah, 01h
            int 21h
            cmp al, 'p'
            je salir_Pausa
            cmp al, 'e'
            je salir_Iniciar
            JMP pausa
        salir_Pausa:
        RET
        pausa endp

    salir_Iniciar:
    mov [Nivel_actual], 1
    RET
    Bucle_Delay PROC NEAR

        outer_loop:

        mov cx, 10000 ; Valor inicial para cada bucle interior

        inner_loop:
        loop inner_loop ; Decrementa cx y salta si no es cero
        inc [contador_loop]
        mov ax, [final_loop]
        cmp  [contador_loop], ax
        jle outer_loop ; Salta al bucle exterior
        mov  [contador_loop], 0
        RET
        Bucle_Delay ENDP
    
    Actualizar_Nivel PROC NEAR
        cmp [nivel_actual], 1
        je nivel1
        mov ax, 250
        mov  [final_loop], ax
        dec [nivel_actual]
        mov ax, [nivel_actual]
        mov bl, al            ; Mueve el valor de al a bl
        shl bl, 1             ; Multiplica bl por 2 
        mov ax, [table_Nivel + bx]  ; Usa bx como índice
        mov cx, [final_loop]
        sub cx, ax
        mov [final_loop], cx
        inc  [nivel_actual]  ; Restore nivel_actual
        ret

        nivel1:
        mov  [final_loop], 0
        mov ax, 126
        mov  [final_loop], ax
        ret
        Actualizar_Nivel ENDP

    Dibujar_Cuadro PROC NEAR
        posicion 9,18
        Escribir "-",39
        posicion 15,18
        Escribir "-",39
        mov counter,0
        mov sumar,10
        Cont:
            mov al,10
            add al, counter
            mov sumar, al

            posicion sumar,24
            Escribir "-",1
        
            posicion sumar,18  
            Escribir "-",1

            posicion sumar,56
            Escribir "-",1

            inc counter
            cmp counter,5
            JNE Cont
        RET
        Dibujar_Cuadro ENDP

    Mostrar_Obstaculo PROC NEAR
            posicion fila2, columna2
            mov ah, 09h       ; Funcion para imprimir un caracter en pantalla
            mov al, "A"    ; Caracter a imprimir (ASCII 219)
            mov bh, 0h        ; Pagina 0
            mov bl, 02h       ; Atributo de color: Fondo verde (0) y caracter blanco (2)
            mov cx, 03        ; Cantidad de veces que se imprime el caracter
            mov dh, fila2      ; Fila
            mov dl, columna2   ; Columna
            int 10H
            mov al, columnaMin2
            cmp columna2, al
            jl columnaLimiteMin2
            JMP Seguir
            columnaLimiteMin2:
            mov al,columnaMax2
            mov columna2, al
            Seguir:
            ret
        Mostrar_Obstaculo ENDP
    Mostrar_Avatar PROC NEAR
        posicion fila, columna
        mov ah, 09h       ; Funcion para imprimir un caracter en pantalla
        mov al, "E"    ; Caracter a imprimir (ASCII 219)
        mov bh, 0h        ; Pagina 0
        mov bl, 02h       ; Atributo de color: Fondo verde (0) y caracter blanco (2)
        mov cx, 03        ; Cantidad de veces que se imprime el caracter
        mov dh, fila      ; Fila
        mov dl, columna   ; Columna
        int 10H
        RET
        Mostrar_Avatar ENDP
    Mostrar_Datos PROC NEAR
    CALL Limpia  
    CALL Colocar_Cursor
    mov ah, 09h
    lea dx, Print_Nombre
    int 21h
    mov ah, 09h
    lea dx, Nombre
    int 21h
    mov ah, 09h
    lea dx, Print_Nivel
    int 21h
    Call LlenarCadena
    ;;;;;;;;;;;;;;;;
    MOV AX, Nivel_actual      ; Cargar el valor de 'count' en AX
	MOV DX, OFFSET suma
    CALL INT_TO_STR   ; Llama a una funcion para convertir el numero en una cadena
    MOV AH, 09h        ; Servicio para imprimir una cadena
    MOV DX, OFFSET suma ; DX apunta a la cadena
    INT 21h     
  
    RET


    INT_TO_STR PROC
    ; Convierte el numero en AX en una cadena y almacena la cadena en 'suma'
    ; Esta funcion asume que el numero es menor o igual a 65535 (maximo valor de un registro AX)

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 10          ; Divisor para convertir en decimal
    XOR BX, BX          ; BX se usa para mantener el índice en 'suma'
    MOV DI, OFFSET suma + 2   ; Puntero al final de la cadena
    MOV BYTE PTR [DI], '$' ; Fin de cadena nul-terminada

    ConvertLoop:
        XOR DX, DX
        DIV CX              ; Dividir AX por 10, resultado en AX, residuo en DX
        ADD DL, '0'         ; Convertir el residuo en caracter
        DEC DI
        MOV [DI], DL        ; Almacenar el caracter en 'suma'
        INC BX
        TEST AX, AX
    JNZ ConvertLoop

    LEA SI, [DI]        ; SI apunta al inicio de la cadena (justo después de '$')
    MOV DI, OFFSET suma       ; DI apunta al destino de la cadena
    MOV CX, BX          ; CX contiene la longitud de la cadena

    CopyLoop:
        LODSB               ; Cargar un byte desde SI
        STOSB               ; Almacenar el byte en DI
        LOOP CopyLoop

    POP DX
    POP CX
    POP BX
    POP AX

    RET
    INT_TO_STR ENDP

    LlenarCadena proc near
    mov si, 00h
    LlenarCadena1:
    mov al, '$'
    repne scasb ; Busca el caracter '$' en la cadena.
    mov al, '0' ; Reemplaza el '$' encontrado por un caracter nulo.
    mov suma[si], al
    inc si
    cmp si, 2
    jl LlenarCadena1
        RET
    LlenarCadena ENDP
    Mostrar_Datos ENDP

    Iniciar ENDP
Acerca PROC NEAR
    CALL Limpia
    CALL Colocar_Cursor
    MOV BYTE PTR [ENDCDE], 00 
    MOV WORD PTR [HANDLE], ?  
    MOV BYTE PTR [Caracter], 0 
    
    CALL Abrir ; Abre archivo, designa DTA
    CMP ENDCDE, 00 ; ¿Apertura válida?
    JNZ Fin_Acerca ; No, salir

    CicloLEER:
    CALL LeerRegistro ; Lee registro en disco
    CMP ENDCDE, 00 ; ¿Lectura normal?
    JNZ Fin_Acerca ; No, salir
    CALL Mostrar_Caracter ; Sí, desplegar nombre
    JMP CicloLEER ; Continuar

    Fin_Acerca:
    mov ah, 01h
    int 21h
    cmp al, 0dh 
    je Salir_Acerca

    Salir_Acerca:
    RET

    
    Abrir PROC NEAR
        MOV AH, 3DH ; Petición para abrir
        MOV AL, 00 ; Archivo normal
        LEA DX, Archivo_Acerca
        INT 21H
        JC Error2 ; ¿Error?
        MOV HANDLE, AX 
        RET

        Error2:
        MOV ENDCDE, 1 ; Sí,
        RET
        Abrir ENDP

    LeerRegistro PROC NEAR
        MOV AH,3FH ;Petición de lectura
        MOV BX,HANDLE
        MOV CX, 1;•3 0 para el nombre + 2 para C
        LEA DX,Caracter
        INT 21H
        CMP AX, 00 ;¿Fin del archivo?
        JE Error3
        RET

        Error3:
        MOV ENDCDE, 1
        RET

    LeerRegistro ENDP

    Mostrar_Caracter PROC NEAR
        MOV AH, 40h
        MOV BX, 1
        LEA DX, Caracter
        INT 21H
        RET
        Mostrar_Caracter ENDP
    
    Acerca ENDP 
Fin PROC NEAR
    mov ah, 4ch
    int 21h
    Fin ENDP

Limpia PROC NEAR         
   mov ax,0600h
   mov bh,17h
   mov cx,0000h
   mov dx,184fh
   int 10h
   ret
    Limpia  endp

Colocar_Cursor PROC NEAR
    MOV AH, 02H
    MOV BH,00
    MOV DH, ROW
    MOV DL,00
    INT 10H
    RET
    Colocar_Cursor ENDP

END