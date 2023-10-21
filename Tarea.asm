
.model small
.stack 100h
.data
filename db 'mi_archivo.txt',0
buffer db 128 dup(0)
handle dw ?
bytes_read dw 0
imprimir macro texto
    mov ah, 9
    mov dx, offset texto
    int 21h
    mov ah, 0   ; Restaurar ah al valor original (puede ser diferente)
endm
msgError1 db 10,13, "Error: No se pudo abrir el archivo", "$"
msgError2 db 10,13, "Error: No se pudo leer el archivo", "$"
fragmento db 11 dup("$")
limpiar db 11 dup("$")
.code
   mov ax, @DATA
   mov ds, ax
   
  abrir:
  mov ah, 3dh
  mov al, 0
  mov dx, offset filename
  int 21h
  jc error1
  mov handle, ax
  
  
  leer:
  mov ah, 3fh
  mov bx, handle
  mov dx, offset buffer
  mov cx, 128
  int 21h
  jnc  imprimir_buffer  
  jmp error2
  imprimir_buffer:
  imprimir buffer 
   mov ah, 0
    int 16h
    jmp Fin
  error1:
  imprimir msgError1
    error2:
  imprimir msgError2
  
  Fin:
  mov ah, 4ch
  int 21h
  end
