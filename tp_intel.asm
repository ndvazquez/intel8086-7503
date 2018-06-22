;************************************************
;                                               *
; TP Intel - Manejo de conjuntos (I)            *
;                                               *
;************************************************

segment pila stack
                resb 64

segment datos data
        msgInicio   db      "TP Intel - Manejo de conjuntos (I)$"
        msgMenu     db      "***Menu Principal***$"
        msgOpt1     db      "1 - Ver si un elemento pertenece al conjunto$"
        msgOpt2     db      "2 - Ver si dos conjuntos son iguales$"
        msgOpt3     db      "3 - Ver si A esta incluido en B$"
        msgOpt4     db      "4 - Salir$"
        msgOpt5     db      "Ingrese la opcion deseada: $"
        msgCant     db      "Ingrese cantidad de conjuntos a cargar: $"
        msgConj     db      "Ingrese el conjunto usando caracteres alfanumericos: $"
        msgElem     db      "Ingrese un elemento: $"
        msgConjDes  db      "Ingrese el conjunto deseado: $"
        saltoLinea  db      10,13,"$"
        msgError1   db      "ERROR: Ingreso un conjunto invalido$"
        msgError2   db      "ERROR: Ingreso un elemento invalido$"
        msgError3   db      "ERROR: Conjunto fuera de rango$"
        msgError4   db      "ERROR: Ingreso una cantidad de conjuntos invalida$"
        msgNoPerte  db      "RESULTADO: El elemento no pertenece al conjunto$"
        msgPerte    db      "RESULTADO: El elemento pertenece al conjunto$"
        msgNoIgual  db      "RESULTADO: Los conjuntos no son iguales$"
        msgIgual    db      "RESULTADO: Los conjuntos son iguales$"
        msgNoInclu  db      "RESULTADO: El conjunto A no esta incluido en B$"
        msgIncluido db      "RESULTADO: El conjunto A esta incluido en B$"
        contador    db   0
        uno         db   1
        cantSet     resb 1
        conjA       resb 1
        igualFin    db   0
                    db   3
                    db   0
        elemento    db   3
                    db   41
                    db   0
        buffer      times 41    resb 1
        set1        times 41    resb 1 
        long1       resb 1
        set2        times 41    resb 1 
        long2       resb 1
        set3        times 41    resb 1 
        long3       resb 1
        set4        times 41    resb 1
        long4       resb 1
        set5        times 41    resb 1 
        long5       resb 1
        set6        times 41    resb 1 
        long6       resb 1

segment codigo code
..start:
        mov     ax,datos    
        mov     ds,ax
        mov     es,ax
        mov     ax,pila
        mov     ss,ax
        ;Se cargan los conjuntos antes del menu
cantidadConj:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgInicio]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgCant] ;pido cantidad de conjuntos a cargar
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        mov     [cantSet],al ;guardo la cantidad de conjuntos a ingresar en cantSet
        lea     dx,[saltoLinea]
        call    imprMsg
        mov     al,[cantSet] ;valido que la cantidad de conjuntos tenga sentido
        cmp     al,6 
        jg      errorCantidad
        cmp     al,1
        jl      errorCantidad
        jmp     cargarSet   
errorCantidad:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgError4]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        xor     al,al
        jmp cantidadConj
imprMsg:
        mov     ah,9
        int     21h
        ret 
validar:
        mov     cx,si ;copio a CX el largo de la cadena a validar
loopVal:
        call    valMayuscula
        inc     di ;avanzo al siguiente byte de la string
        loop    loopVal
        ret
valMayuscula:
        cmp     byte[di],65 ;chequeo si es menor que A
        jl      valNum
        cmp     byte[di],90 ;chequeo si es mayor que Z
        jg      valNum
        ret
valNum:
        cmp     byte[di],48 ;chequeo si es menor que 0
        jl      flagNoVal
        cmp     byte[di],57 ;chequeo si es mayor que 9, ya se que no es mayuscula
        jg      flagNoVal
        ret
flagNoVal:
        add     ah,1 ;cambio el flag a 1
        ret     
cargarSet:
        mov     al,[contador] 
        add     al,1
        mov     [contador],al ;actualizo contador
        cmp     al,[cantSet]
        jg      menu ;termine de cargar, voy al menu
recargarSet:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgConj]
        call    imprMsg
        lea     dx,[buffer-2] ;desplazamiento del buffer para recibir input
        mov     ah,0ah ;servicio para copiar cadena input
        int     21h
        mov     ax,0
        mov     al,[buffer-1]
        mov     si,ax
        mov     byte[buffer+si],'$' ; fin de cadena
        test    al,1 ;testeamos si introdujeron una cantidad correcta de caracteres
        jz      par
        call    errorCargaSet
par:
        mov     ah,0 ;seteo flag para saber si es valido el conjunto
        lea     di,[buffer] ;cargo offset del buffer en DI para validarlo
        call    validar ;valido el buffer
        cmp     ah,0
        jne     errorCargaSet
        mov     al,byte[contador]
        call    cargarConjunto
        jmp     copiarSet
copiarSet:
        mov     al,[buffer-1]
        mov     [di+41],al ;copio la longReal del set
        mov     cx,41 ;largo del buffer
        lea     si,[buffer]
    rep movsb
        xor     si,si 
        xor     di,di
        mov     byte[buffer-1],0
        jmp     cargarSet
errorCargaSet:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgError1] ;mensaje de error en conjunto ingresado
        call    imprMsg
        xor     ax,ax
        jmp     recargarSet                 
cargarConjunto:
        cmp     al,1
        je      carga1
        cmp     al,2
        je      carga2
        cmp     al,3
        je      carga3
        cmp     al,4
        je      carga4
        cmp     al,5
        je      carga5
        cmp     al,6
        je      carga6
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgError3]
        call    imprMsg
        jmp     menu 
retConj:
        ret
carga1:
        lea     di,[set1]
        jmp     retConj
carga2:
        lea     di,[set2]
        jmp     retConj
carga3:
        lea     di,[set3]
        jmp     retConj
carga4:
        lea     di,[set4]
        jmp     retConj
carga5:
        lea     di,[set5]
        jmp     retConj
carga6:
        lea     di,[set6]
        jmp     retConj
menu:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgMenu]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgOpt1]
        call    imprMsg 
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgOpt2]
        call    imprMsg 
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgOpt3]
        call    imprMsg 
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgOpt4]
        call    imprMsg 
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgOpt5]
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        cmp     al,1
        je      contieneElem
        cmp     al,2
        je      conjIguales
        cmp     al,3
        je      conjInclu
        cmp     al,4
        je      salir
        jmp     menu
contieneElem:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgElem]
        call    imprMsg
        lea     dx,[elemento-2]
        mov     ah,0ah
        int     21h
        mov     ax,0
        mov     al,[elemento-1]
        mov     si,ax
        mov     byte[elemento+si],'$' ; fin de cadena
        cmp     al,2 ;chequeamos que se hayan ingresado dos caracteres (un elemento)
        jne     errorElem 
        mov     ah,0 ;seteo flag para validar el elemento
        lea     di,[elemento] ;cargo direccion del elemento
        call    validar
        cmp     ah,0 ;chequeo si validar cambio el flag
        jne     errorElem ;si no es valida, voy a errorElem
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgConjDes]
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        call    cargarConjunto
        mov     al,[di+41]
loopComp1:
        mov     cx,2
        lea     si,[elemento]
   repe cmpsb   
        je      elemPertenece
        inc     di
        sub     al,2 ;ya iteré, resto 2 al largo del conjunto
        cmp     al,0
        jne     loopComp1 ;chequeo el proximo elemento del conjunto
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgNoPerte]
        call    imprMsg
        jmp     menu
elemPertenece:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgPerte]
        call    imprMsg
        jmp     menu        
errorElem:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgError2]
        call    imprMsg
        jmp     contieneElem
conjIguales:
        ;Chequeo que AcB y BcA
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgConjDes]
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        mov     [conjA],al ;guardo ID de A para el swap que hago despues
        call    cargarConjunto
        lea     si,[di] ;copio el primer conjunto a SI
        xor     di,di
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgConjDes]
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        call    cargarConjunto
        mov     al,[si+41] ;guardo largo de A en AL
        mov     ah,[di+41] ;guardo largo de B en AH
        cmp     al,ah
        jne     noIguales ;si miden distinto no pueden ser iguales
        lea     bx,[di] ;guardo dir de inicio de B en BX
        jmp     loopComp2
loopComp2:
        mov     cx,2
   repe cmpsb
        je      otroElem ;avanzo al siguiente elem de A
        dec     si ;reseteo el elem de A
        inc     di ;siguiente elem de B
        sub     al,2 ;avanzo el contador
        cmp     al,0
        jne     loopComp2
        jmp     noIguales
otroElem:
        lea     di,[bx] ;reseteo DI
        mov     al,[di+41] ;reseteo el contador
        sub     ah,2 ;bajo el contador de B
        cmp     ah,0 ;veo si estoy en el fin de cadena 
        je      swapConj
        jmp     loopComp2
swapConj:
        mov     ah,[igualFin]
        add     ah,1
        mov     [igualFin],ah
        cmp     ah,2 ;si intento swapeear por segunda vez, termine
        je      sonIguales
        lea     si,[di] ;swapeo A por B
        mov     al,[conjA] ;cargo el ID de A
        call    cargarConjunto ;cargo el conjunto A en DI
        lea     bx,[di] ;cargo DI en BX para reiniciarlo
        mov     ah,[di+41]
        mov     al,[si+41]
        jmp     loopComp2
noIguales:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgNoIgual]
        call    imprMsg
        jmp     menu
sonIguales:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgIgual]
        call    imprMsg
        jmp     menu
conjInclu:
        ;chequeo si AcB
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgConjDes]
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        call    cargarConjunto
        lea     si,[di] ;copio el primer conjunto a SI
        xor     di,di
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgConjDes]
        call    imprMsg
        mov     ah,1h ;servicio para guardar un caracter de stdin
        int     21h
        sub     al,30h
        call    cargarConjunto
        mov     al,[di+41] ;guardo largo de B en AL
        mov     ah,[si+41] ;guardo largo de A en AH 
        lea     bx,[di] ;guardo dir de inicio de B en BX
        jmp     loopComp3
loopComp3:
        mov     cx,2
   repe cmpsb
        je      otroElem2 ;avanzo al siguiente elem de A
        dec     si ;reseteo el elem de A
        inc     di ;siguiente elem de B
        sub     al,2 ;avanzo el contador
        cmp     al,0
        jne     loopComp3
        jmp     noIncluido
otroElem2:
        lea     di,[bx] ;reseteo DI
        mov     al,[di+41] ;reseteo el contador
        sub     ah,2 ;bajo el contador de elementos de A
        cmp     ah,0 ;veo si estoy en el fin de cadena 
        je      siIncluido
        jmp     loopComp3
noIncluido:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgNoInclu]
        call    imprMsg
        jmp     menu
siIncluido:
        lea     dx,[saltoLinea]
        call    imprMsg
        lea     dx,[msgIncluido]
        call    imprMsg
        jmp     menu
salir:
        mov ax,4c00h
        int 21h