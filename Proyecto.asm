.MODEL SMALL
.STACK 100h
.DATA
    ENDCDE DB 00 
    HANDLE DW ?
    Caracter DB ?
    ROW DB 00
  ;Datos para mostrar  
    Abrir_MSG DB 10,13,'ERROR AL ABRIR EL ARCHIVO$'
    Mensaje_Menu DB "Bienvenido al Menu", 10, 13, "$"
    Mensaje_Seleccion DB "Digite el numero para seleccionar una opcion", 10, 13, "$"
    Mensaje_Establecer DB "1-Establecer nivel y nombre del jugador", 10, 13, "$"
    Mensaje_Nombre DB "Al finalizar precione enter", 10,13, 10, 13,"Ingrese su nombre (Con un maximo de 20 caracteres)", 10, 13, "$"
    Mensaje_Nivel DB 10, 13, "Ingrese el nivel de dificultad", 10,13 ,"(Con un maximo de 2 caracteres, solo se tomara en cuenta numeros)", 10, 13, "$"
    Mensaje_Escenario DB "2-Seleccione el escenario", 10, 13, "$"
    Mensaje_Iniciar DB "3-Iniciar juego", 10, 13, "$"
    Mensaje_Acerca DB "4-Acerca de", 10, 13, "$"
    Mensaje_Fin DB "5-Salir", 10, 13, "$"
    Nombre DB 20 dup('$')
    Nivel DB 3 dup('$')
    Archivo_Acerca DB "Acerca.txt", 0
    Print_Nombre DB "Nombre del Jugador: $"
    Print_Nivel DB "Nivel de dificultad: $"
    Print_Puntos_Obtenidos DB "Puntos obtenidos: $"
    Print_Dato_Actual DB 7 dup("$")
    Salir_Puntos_Print db "Presione Cualquier tecla para salir", 10, 13, "$"
    Print_Instrucciones DB "Instrucciones: ", 10, 13, "Para moverse arriba presione la tecla 'w' o la flecha hacia arriba", 10, 13, "Para moverse abajo presione la tecla 's' o la flecha hacia abajo", 10, 13, "Para pausar el juego presione la tecla 'p'", 10, 13, "Para subir de nivel presione la tecla 'n'", 10, 13, "Para salir del juego presione la tecla 'e'", 10, 13, "$"
  ;variables para el juego
    Archivo_Puntos DB "Puntajes.txt", 0
    BUFFER Db 7 DUP("$")
    BUFFER2 Db 7 DUP("$")
    BUFFER3 Db 7 DUP("$")
    Print_Ranking_Puntos db "Maximos Puntajes Optenidos: $"
    print_coma db ","
    Puntos1 dw 0
    Puntos2 dw 0
    Puntos3 dw 0
    revizar_datos db 0
    cantidad_comas db 0
    Max_Mostrar_Datos dw 0
    cuadro_Personaje DB 219
    filaLimiteMin DB 10
    filaLimiteMax DB 14
    fila DB 12
    columna DB 20
    counter DB 10
    sumar DB 10
    contar_ciclos db 0
    puntos_Obtenidos dw 1
    vidas db 3
    ;carga y muestra de patron
    cuadro db 219        ; Caracter ASCII para representar el cuadro verde
    Archivo DB 'mapa.txt',0 ; Nombre del archivo
    vector0 db 30 dup(?)  ; Vector de longitud 30
    vector1 db 30 dup(?)  ; Vector de longitud 30
    vector2 db 30 dup(?)  ; Vector de longitud 30
    vector3 db 30 dup(?)  ; Vector de longitud 30
    vector4 db 30 dup(?)  ; Vector de longitud 30 
    num db 10
    ccc db 10

    similar macro vectr   ;encargado de comparar
        local down
        lea di,vectr
        mov al, [di]      ; Carga el valor del elemento actual
        cmp al,'a'
        jne down
        dec vidas
        down:
        endm
    avanzar macro vect    ;encargado de corrimiento de vector
        local shift
        mov cx,29
        lea di,vect
        shift:
            mov al, [di]          ; Carga el valor del elemento actual
            mov bl, [di + 1]      ; Carga el valor del elemento siguiente
            mov [di], bl          ; Coloca el valor del siguiente elemento en la posición actual
            mov [di + 1], al      ; Coloca el valor actual en la posición siguiente
            inc di
            loop shift
        endm
    posicion macro x, y 
        mov ah, 02h
        mov bh, 00h
        mov dh, x
        mov dl, y
        int 10h
        endm
    printVector macro vect
        local print_loop, pared,contin,camin
        mov cx,30
        lea di,vect+29
        mov bl, 70h       ; selecciona color
        print_loop:
            mov ah, 09h    ; Función 02h: Imprimir carácter en pantalla
            mov al, [di]   ; Carga el carácter actual en aL
            mov bh, 0h     ; Página 0
            cmp al, 'a'
            jne camin
            mov bl, 70h
            mov al, cuadro
            jmp contin
            camin:
            mov bl, 01h
            mov al, cuadro
            contin:
                int 10h        ; Llama a la interrupción 21h para imprimir el carácter
                dec di         ; Avanza al siguiente elemento
            loop print_loop
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
    primer_Segundo db 0
    segundo_Se db 0
    aux_primer_se db 0
    resultado_resta db 0

.CODE
MOV AX, @DATA
MOV DS, AX 
Inicio:
    mov puntos_Obtenidos , 1
    CALL Limpia
    CALL Colocar_Cursor
    CALL Mostrar_Inicio
    CALL Seleccion
    JMP Inicio
Mostrar_Inicio PROC NEAR
    posicion 4, 30
    mov AH, 09h 
	lea dx, Mensaje_Menu
	int 21h
    posicion 6, 18
    mov AH, 09h
    lea dx, Mensaje_Seleccion
    int 21h
    posicion 8, 20
    mov AH, 09h
    lea dx, Mensaje_Establecer
    int 21h
    posicion 10, 26
    mov AH, 09h
    lea dx, Mensaje_Escenario
    int 21h
    posicion 12, 31
    mov AH, 09h
    lea dx, Mensaje_Iniciar
    int 21h
    posicion 14, 33
    mov AH, 09h
    lea dx, Mensaje_Acerca
    int 21h
    posicion 16, 35
    mov AH, 09h
    lea dx, Mensaje_Fin
    int 21h
    RET
    Mostrar_Inicio ENDP

Seleccion PROC NEAR
    posicion 18, 36
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
    posicion 1,30
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
    
    posicion 5, 0
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
        DEC ax
        mov [Nivel_actual], ax  ; Almacena el valor numérico en Nivel_actual
        CALL Actualizar_Nivel
        ret
    Nivel_Menor:
        mov ax, 1
        DEC ax
        mov [Nivel_actual], ax  ; Almacena el valor numérico en Nivel_actual
        CALL Actualizar_Nivel
        ret
    Nivel_Mayor:
        mov ax, 15
        DEC ax
        mov [Nivel_actual], ax  ; Almacena el valor numérico en Nivel_actual
        CALL Actualizar_Nivel
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
    mov AH, 2ch
    int 21H
    mov primer_Segundo, dh
    call niveles_auto
    RET
    Escenario ENDP
Iniciar PROC NEAR    
    ;cambios Brian
    CALL Abrir_Archi
    CALL Llenar_Vector
    CALL Llenar_Vector1
    CALL Llenar_Vector2
    CALL Llenar_Vector3
    CALL Llenar_Vector4
    ;fin cambios
    mov AH, 2ch
    int 21H
    mov primer_Segundo, dh
    ciclo:
    mov [segundo_Se], 0
    CALL Mostrar_Datos
    call Bucle_Delay

    mov ah, 01h
    int 16h  ; Se preciona una tecla?

<<<<<<< HEAD
=======


>>>>>>> 11ebe6882443802c6bf07bd76d5bbe8e08e329ee
    jz sin_tecla_presionada; Si se preciona una tecla, entonces se lee el codigo de la tecla 
    mov ah, 00h
    int 16h
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
       call compare
       
    cmp vidas,0
    je salir_Iniciar
    sin_tecla_presionada:
    cmp contar_ciclos, 10
    jge aumentar_nivel
    inc contar_ciclos
    call compare
    cmp vidas,0
    je salir_Iniciar
    jmp ciclo
    aumentar_nivel:
        mov contar_ciclos, 0
        call niveles_auto
        jmp ciclo
    pausa_Llamar:
            call pausa
            jmp ciclo
        subir_nivel:
            mov ax, [Nivel_actual]
            cmp al, 15
            je ciclo
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
           salir_Iniciar:
    CALL Mostrar_Puntajes_de_Archivo
    mov [Nivel_actual], 1
    mov [puntos_Obtenidos], 1
    RET
        pausa proc near
            CALL Limpia
            CALL Mostrar_Datos
        
            CALL Dibujar_Cuadro
            CALL Mostrar_Avatar
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
        inc [Nivel_actual]
        mov [segundo_Se], 0
        mov ax, 250
        mov  [final_loop], ax
        MOV AX, Nivel_actual      ; Cargar el valor de 'count' en AX
        dec ax
        mov bl, al            ; Mueve el valor de al a bl
        shl bl, 1             ; Multiplica bl por 2
        mov ax, [table_Nivel + bx]  ; Usa bx como índice
        mov cx, [final_loop]
        sub cx, ax
        mov [final_loop], cx
        ret
    Actualizar_Nivel ENDP

    ;antiguo disenno Marco de juego
    Dibujar_Cuadro PROC NEAR
        posicion 9,18
        Escribir "-",40
        posicion 15,18
        Escribir "-",40
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

            posicion sumar,57
            Escribir "-",1

            inc counter
            cmp counter,5
            JNE Cont
        RET
    Dibujar_Cuadro ENDP

    

    ;Avatar
    Mostrar_Avatar PROC NEAR
        posicion fila, columna
        mov ah, 09h       ; Funcion para imprimir un caracter en pantalla
        mov al, " "    ; Caracter a imprimir (ASCII 219)
        mov bh, 0h        ; Pagina 0
        mov bl, 02h       ; Atributo de color: Fondo verde (0) y caracter blanco (2)
        mov cx, 03        ; Cantidad de veces que se imprime el caracter
        mov dh, fila      ; Fila
        mov dl, columna   ; Columna
        int 10H
        RET
    Mostrar_Avatar ENDP

    ;Encargado de comparar
    compare PROC
        mov dl,fila
        sub dl, 10
        cmp dl,0
        je vervctr0
        cmp dl,1
        je vervctr1
        cmp dl,2
        je vervctr2
        cmp dl,3
        je vervctr3
        cmp dl,4
        je vervctr4
        jmp final
        vervctr0:
            similar vector0
            jmp final
        vervctr1:
            similar vector1
            jmp final
        vervctr2:
            similar vector2
            jmp final
        vervctr3:
            similar vector3
            jmp final
        vervctr4:
            similar vector4
            jmp final
        final:
        ret
    compare ENDP

    ;Serie de llenado de vectores
    Llenar_Vector PROC
        lea di, vector0
        lercar:
            mov cx, 1 ; Leer un solo caracter
            mov Caracter,0
            mov ccc,0
            lopo:
                mov num,0
                MOV AH, 3FH ; Peticion de lectura
                MOV BX, HANDLE
                LEA DX, Caracter ; Almacena el caracter leído
                INT 21H
                mov al, Caracter
                cmp al, 0Dh ; Fin de linea?
                je lopo
                cmp al, 0Ah ; salto de linea?
                je finn
                repet:
                mov [di],al
                inc di
                inc num
                cmp num, 6
                jne repet
                loop lopo
                inc ccc
                cmp ccc,5
                jne lercar
            finn: 
        ret
    Llenar_Vector ENDP
    Llenar_Vector1 PROC
        lea di, vector1
        lercar1:
            mov cx, 1 ; Leer un solo caracter
            mov Caracter,0
            mov ccc,0
            lopo1:
                mov num,0
                MOV AH, 3FH ; Peticion de lectura
                MOV BX, HANDLE
                LEA DX, Caracter ; Almacena el caracter leído
                INT 21H
                mov al, Caracter
                cmp al, 0Dh ; Fin de linea?
                je lopo1
                cmp al, 0Ah ; salto de linea?
                je finn1
                repet1:
                mov [di],al
                inc di
                inc num
                cmp num, 6
                jne repet1
                loop lopo1
                inc ccc
                cmp ccc,5
                jne lercar1
            finn1: 
        ret
    Llenar_Vector1 ENDP
    Llenar_Vector2 PROC
        lea di, vector2
        lercar2:
            mov cx, 1 ; Leer un solo caracter
            mov Caracter,0
            mov ccc,0
            lopo2:
                mov num,0
                MOV AH, 3FH ; Peticion de lectura
                MOV BX, HANDLE
                LEA DX, Caracter ; Almacena el caracter leído
                INT 21H
                mov al, Caracter
                cmp al, 0Dh ; Fin de linea?
                je lopo2
                cmp al, 0Ah ; salto de linea?
                je finn2
                repet2:
                mov [di],al
                inc di
                inc num
                cmp num, 6
                jne repet2
                loop lopo2
                inc ccc
                cmp ccc,5
                jne lercar2
            finn2:
        ret
    Llenar_Vector2 ENDP
    Llenar_Vector3 PROC
        lea di, vector3
        lercar3:
            mov cx, 1 ; Leer un solo caracter
            mov Caracter,0
            mov ccc,0
            lopo3:
                mov num,0
                MOV AH, 3FH ; Peticion de lectura
                MOV BX, HANDLE
                LEA DX, Caracter ; Almacena el caracter leído
                INT 21H
                mov al, Caracter
                cmp al, 0Dh ; Fin de linea?
                je lopo3
                cmp al, 0Ah ; salto de linea?
                je finn3
                repet3:
                mov [di],al
                inc di
                inc num
                cmp num, 6
                jne repet3
                loop lopo3
                inc ccc
                cmp ccc,5
                jne lercar3
            finn3: 
        ret
    Llenar_Vector3 ENDP
    Llenar_Vector4 PROC
        lea di, vector4
        lercar4:
            mov cx, 1 ; Leer un solo caracter
            mov Caracter,0
            mov ccc,0
            lopo4:
                mov num,0
                MOV AH, 3FH ; Peticion de lectura
                MOV BX, HANDLE
                LEA DX, Caracter ; Almacena el caracter leído
                INT 21H
                mov al, Caracter
                cmp al, 0Dh ; Fin de linea?
                je lopo4
                cmp al, 0Ah ; salto de linea?
                je finn4
                cmp al, 00h ; Fin de archivo?
                je finn4
                repet4:
                mov [di],al
                inc di
                inc num
                cmp num, 6
                jne repet4
                loop lopo4
                inc ccc
                cmp ccc,5
                jne lercar4
            finn4:
        ret
    Llenar_Vector4 ENDP
    
    ;Abrir archivo
    Abrir_Archi PROC 
      MOV AH, 3DH ; Peticion para abrir
      MOV AL, 00 ; Archivo normal
      LEA DX, Archivo
      INT 21H
      JC Error_Abrir ; Error?
      MOV HANDLE, AX ; no, guardar manejador
      RET
      Error_Abrir:
         MOV ENDCDE, 01 ; si,
         mov AH, 09h
         LEA DX, Abrir_MSG ; desplegar
         INT 21H
         RET
   Abrir_Archi ENDP

    ;Datos
    Mostrar_Datos PROC NEAR
        CALL Limpia 
        posicion 19, 0
        MOV AH, 09h       ; Función 09h - Imprimir cadena
        LEA DX, Print_Instrucciones ; Dirección de la cadena
        INT 21h
        posicion 1, 0
        mov ah, 09h
        lea dx, Print_Nombre
        int 21h
        posicion 1, 21
        mov ah, 09h
        lea dx, Nombre
        int 21h

        posicion 3, 0
        mov ah, 09h
        lea dx, Print_Nivel
        int 21h
        mov Max_Mostrar_Datos, 2
        Call LlenarCadena
        MOV AX, Nivel_actual      ; Cargar el valor de 'count' en AX
        MOV DX, OFFSET Print_Dato_Actual
        CALL INT_TO_STR   ; Llama a una funcion para convertir el numero en una cadena
        posicion 3, 22
        MOV AH, 09h        ; Servicio para imprimir una cadena
        MOV DX, OFFSET  Print_Dato_Actual ; DX apunta a la cadena
        INT 21h     
        posicion 1, 40
        mov ah, 09h
        lea dx, Print_Puntos_Obtenidos
        int 21h
        mov Max_Mostrar_Datos, 5
        Call LlenarCadena
        ;dibujar los vectores en pantalla
        posicion 10,26
        printVector vector0
        avanzar vector0
        
        posicion 11,26
        printVector vector1
        avanzar vector1
        
        posicion 12,26
        printVector vector2
        avanzar vector2
        
        posicion 13,26
        printVector vector3
        avanzar vector3
        
        posicion 14,26
        printVector vector4
        avanzar vector4
        ;fin dibujar vectores en pantalla
        

        call Mostrar_Avatar
        
        MOV AX, puntos_Obtenidos      ; Cargar el valor de 'count' en AX
        MOV DX, OFFSET Print_Dato_Actual
        CALL INT_TO_STR  ; Llama a una funcion para convertir el numero en una cadena
        posicion 1, 60
        MOV AH, 09h        ; Servicio para imprimir una cadena
        MOV DX, OFFSET  Print_Dato_Actual ; DX apunta a la cadena
        INT 21h 
        
    CALL Dibujar_Cuadro
        RET
        INT_TO_STR PROC
        ; Esta funcion asume que el numero es menor o igual a 65535 (maximo valor de un registro AX)
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        
        MOV CX, 10          ; Divisor para convertir en decimal
        XOR BX, BX  
        mov bx, Max_Mostrar_Datos        
        add  bx, OFFSET Print_Dato_Actual  ; Puntero al final de la cadena
        mov di, bx          ; DI apunta al final de la cadena
        MOV BYTE PTR [DI], '$' ; Fin de cadena nul-terminada
        XOR BX, BX 
        ConvertLoop:
            XOR DX, DX
            DIV CX              ; Dividir AX por 10, resultado en AX, residuo en DX
            ADD DL, '0'         ; Convertir el residuo en caracter
            DEC DI
            MOV [DI], DL       
            INC BX
            TEST AX, AX
        JNZ ConvertLoop

        LEA SI, [DI]        ; SI apunta al inicio de la cadena (justo después de '$')
        MOV DI, OFFSET Print_Dato_Actual       ; DI apunta al destino de la cadena
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
        mov Print_Dato_Actual[si], al
        inc si
        cmp si, Max_Mostrar_Datos
        jl LlenarCadena1
            RET
    LlenarCadena ENDP

    Mostrar_Datos ENDP

    niveles_auto PROC
        inc [puntos_Obtenidos]
        mov [segundo_Se], 0
        mov ah, 2ch
        int 21H
        mov segundo_Se, dh
        mov al, primer_Segundo
        cmp segundo_Se, al
        jle es_menor
        jmp es_mayor

        es_menor:
        mov bl, 60
        add bl, segundo_Se
        sub bl, primer_Segundo
        mov resultado_resta, bl
        cmp resultado_resta, 20
        jl salir_niveles_auto
        jge subir_nivel_auto
        jmp salir_niveles_auto

        es_mayor:
        sub segundo_Se, al
        cmp segundo_Se, 20
        jl salir_niveles_auto
        jge subir_nivel_auto
        jmp salir_niveles_auto

        subir_nivel_auto:
        mov [primer_Segundo], 0
        mov [segundo_Se], 0
        mov [aux_primer_se], 0
        mov [resultado_resta], 0
        cmp [Nivel_actual], 15
        jge seguir4 
        call Actualizar_Nivel
        seguir4:
        mov ah, 2ch
        int 21H
        mov [primer_Segundo], dh
        RET
        salir_niveles_auto:
        mov [segundo_Se], 0
        RET
    niveles_auto ENDP
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
    JMP CicloLEER 

    Fin_Acerca:
    mov ah, 01h
    int 21h
    cmp al, 0dh 
    je Salir_Acerca

    Salir_Acerca:
    RET

    
    Abrir PROC 
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

    LeerRegistro PROC 
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

    Mostrar_Caracter PROC 
        MOV AH, 40h
        MOV BX, 1
        LEA DX, Caracter
        INT 21H
        RET
        Mostrar_Caracter ENDP
    
    Acerca ENDP 
Fin PROC 
    mov ah, 4ch
    int 21h
    Fin ENDP

Limpia PROC          
   mov ax,0600h
   mov bh,17h
   mov cx,0000h
   mov dx,184fh
   int 10h
   ret
    Limpia  endp

Colocar_Cursor PROC 
    MOV AH, 02H
    MOV BH,00
    MOV DH, ROW
    MOV DL,00
    INT 10H
    RET
    Colocar_Cursor ENDP

Mostrar_Puntajes_de_Archivo PROC
    CALL Limpia
    MOV AH, 02H
    MOV BH,00
    MOV DH, 3
    MOV DL, 0
    INT 10H
    MOV BYTE PTR [ENDCDE], 00 
    MOV WORD PTR [HANDLE], ?  
    MOV BYTE PTR [Caracter], 0 
    Mov SI, 0
    mov di, 0
    CALL Abrir_Puntos ; Abre archivo, designa DTA
    CMP ENDCDE, 00 ; ¿Apertura válida?
    JNZ Fin_Puntos ; No, salir

    CicloLEER_Puntos1:
    CALL LeerRegistro ; Lee registro en disco
    CMP ENDCDE, 00 ; ¿Lectura normal?
    JNZ Continuar_Puntos ; No, salir
    CALL Mover_Datos_Puntos ; Sí, desplegar nombre
    JMP CicloLEER_Puntos1 ; Continuar

    Continuar_Puntos:
    xor si, si
    mov si, offset [BUFFER]     ; Puntero a la cadena
    call cadena_A_Numero
    mov Puntos1, ax
      xor si, si
      mov si, offset [BUFFER2]     ; Puntero a la cadena
      call cadena_A_Numero
      mov Puntos2, ax
      xor si, si
      mov si, offset [BUFFER3]     ; Puntero a la cadena
      call cadena_A_Numero
      mov Puntos3, ax

   call OrdenarDatos
   CALL Escribir_en_Archivo

   Fin_Puntos:
   posicion 0, 1
      mov AH, 09h 
	lea dx, Salir_Puntos_Print
	int 21h
   posicion 2, 1
   mov AH, 09h 
	lea dx, Print_Ranking_Puntos
	int 21h
   Call Mostrar_Puntajes_Ranking
   mov [Nivel_actual], 1
   jmp inicio
    RET

   cadena_A_Numero proc near
    mov cx, 10         ; Inicializa el factor de multiplicación
    xor ax, ax         ; Inicializa el acumulador
    convertir_loop1:
    mov bl, [si]       ; Carga el siguiente carácter de la cadena
    cmp bl, '$'        ; Comprueba si es el final de la cadena
    je  convertir_fin1
    sub bl, '0'         ; Convierte el carácter a valor numérico
    mul cx             ; Multiplica el acumulador por 10
    add ax, bx     ; Suma el valor numérico al acumulador
    inc si             ; Avanza al siguiente carácter
    jmp convertir_loop1
    convertir_fin1:
    RET
   cadena_A_Numero endp
   OrdenarDatos PROC 
         mov revizar_datos, 0
         revizar:
         inc revizar_datos
        ; Comparación e intercambio de Dato1 y Dato2
        mov ax, Puntos1
        mov bx, Puntos2
        call CompararEIntercambiar
        mov Puntos1, ax
        mov Puntos2, bx

        ; Comparación e intercambio de Dato2 y Dato3
        mov ax, Puntos2
        mov bx, Puntos3
        call CompararEIntercambiar
        mov Puntos2, ax
        mov Puntos3, bx
        ; Comparación e intercambio de Dato3 y Dato4
        mov ax, Puntos3
        mov bx, puntos_Obtenidos
        call CompararEIntercambiar
        mov Puntos3, ax
        mov puntos_Obtenidos, bx
         cmp revizar_datos, 4
         jle revizar
        ret

    ; Función para comparar dos valores y realizar el intercambio si es necesario
    CompararEIntercambiar:
        cmp ax, bx
        jge NoIntercambiar
        xchg ax, bx

    NoIntercambiar:
        ret
   OrdenarDatos ENDP 

    Abrir_Puntos PROC 
        MOV AH, 3DH ; Petición para abrir
        MOV AL, 00 ; Archivo normal
        LEA DX, Archivo_Puntos
        INT 21H
        JC Error_Puntos2 ; ¿Error?
        MOV HANDLE, AX 
        RET

        Error_Puntos2:
        MOV ENDCDE, 1 ; Sí,
        RET
        Abrir_Puntos ENDP

   Mover_Datos_Puntos PROC NEAR
      LEA DX, Caracter
      Mov CX, 1 
      CALL Comas_Puntos
      cmp cantidad_comas, 0
      call Guardar_Datos_Puntos
      RET

    Guardar_Datos_Puntos proc near
      cmp cantidad_comas, 1
      jl llenar_buffer
      je llenar_buffer2
      jg llenar_buffer3
      llenar_buffer:
      MOV AL, BYTE PTR [Caracter]
      MOV BYTE PTR [BUFFER + SI], AL
      INC SI
         RET
      llenar_buffer2:
         mov si, 0
         MOV AL, BYTE PTR [Caracter]
         MOV BYTE PTR [BUFFER2 + DI], AL
         INC DI
            RET
      llenar_buffer3:
         MOV AL, BYTE PTR [Caracter]
         MOV BYTE PTR [BUFFER3 + SI], AL
         INC SI
            RET
      Guardar_Datos_Puntos endp
    Comas_Puntos proc near
      CMP BYTE PTR [Caracter], ','
      JE coma_encontrada
      RET
      coma_encontrada:
      INC cantidad_comas
      jmp CicloLEER_Puntos1
      RET
      Comas_Puntos endp
 Mover_Datos_Puntos ENDP             
Escribir_en_Archivo PROC 
   xor ax, ax
   xor bx, bx
   xor cx, cx
   MOV AH, 3CH       ; Función para abrir/crear archivo
   MOV CX, 2         ; Modo de apertura (1: solo escritura, 2: crear o truncar)
   LEA DX, Archivo_Puntos
   INT 21H

   MOV HANDLE, AX   ; Guardar el manejador del archivo
   mov Max_Mostrar_Datos, 6
   Call LlenarCadena
   MOV AX,  Puntos1     
   MOV DX, OFFSET Print_Dato_Actual
   CALL INT_TO_STR 
   ; Escribir Dato1 en el archivo
   MOV AH, 40h      ; Función para escribir en archivo
   MOV BX, HANDLE   
   LEA DX, Print_Dato_Actual    ; Dirección del dato
   MOV CX, 6        ; Longitud del dato en bytes
   INT 21H
   MOV AH, 40h     
   MOV BX, HANDLE   
   LEA DX, print_coma    
   MOV CX, 1       
   INT 21H
   Call LlenarCadena
   MOV AX,  Puntos2     
   MOV DX, OFFSET Print_Dato_Actual
   CALL INT_TO_STR 
   MOV AH, 40h      
   MOV BX, HANDLE   
   LEA DX, Print_Dato_Actual    
   MOV CX, 6        
   INT 21H
   MOV AH, 40h      
   MOV BX, HANDLE   
   LEA DX, print_coma    
   MOV CX, 1       
   INT 21H
   Call LlenarCadena
   MOV AX,  Puntos3    
   MOV DX, OFFSET Print_Dato_Actual
   CALL INT_TO_STR 
   MOV AH, 40h      
   MOV BX, HANDLE   
   LEA DX, Print_Dato_Actual    
   MOV CX, 6        
   INT 21H
   MOV AH, 3Eh      ; Función para cerrar archivo
   MOV BX, HANDLE   
   INT 21H

   RET
 Escribir_en_Archivo ENDP 
   Mostrar_Puntajes_Ranking PROC 
    MOV BYTE PTR [ENDCDE], 00 
    MOV WORD PTR [HANDLE], ?  
    MOV BYTE PTR [Caracter], 0 
    
    CALL Abrir_Puntos ; Abre archivo, designa DTA
    CMP ENDCDE, 00 ; ¿Apertura válida?
    JNZ Fin_Mostrar_Puntos ; No, salir

    CicloLEER_P:
    CALL LeerRegistro ; Lee registro en disco
    CMP ENDCDE, 00 ; ¿Lectura normal?
    JNZ Fin_Mostrar_Puntos ; No, salir
    CALL Mostrar_Caracter ; Sí, desplegar nombre
    JMP CicloLEER_P 

    Fin_Mostrar_Puntos:
    posicion 4, 30
    mov ah, 01h
    int 21h
    cmp al, 0dh 
    je Salir_Mostrar_Puntos

    Salir_Mostrar_Puntos:
    RET
    Mostrar_Puntajes_Ranking ENDP 
Mostrar_Puntajes_de_Archivo ENDP

END