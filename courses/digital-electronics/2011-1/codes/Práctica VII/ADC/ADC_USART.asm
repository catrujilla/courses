	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Junior tu papá! Carlos Alejandro Trujillo Anaya;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	TITLE "Comunicacion_Serial"
	List P = 16F883
	INCLUDE <P16F883.INC>

;MODIFICACION DE LA PALABRA DE CONFIGURACION DEL PIC, CON ESTO SE EVITA COMETER ERRORES EN
;LA PROGRAMACION DEL PIC (COMO PUEDE SER DEJAR EL CODIGO PROTEGIDO)

  __CONFIG _CONFIG1, _HS_OSC & _WDT_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF & _DEBUG_OFF
  __CONFIG _CONFIG2, _WRT_OFF & _BOR40V

; Definicion de variables
OPTREG   	  EQU    	0x81	; Dirrección del OPTION_REG

w_saved       EQU		0x21	; variable utilizada para guardar contexto
status_saved  EQU		0x22	; variable utilizada para guardar contexto
pclath_saved  EQU		0x23	; variable utilizada para guardar contexto
var1          EQU		0x24	; variable de ejemplo
contador1	  EQU		0x25	; Contador para la estabilización
caracter      EQU		0x26	; Registro que contiene el Ascii de la letra que se desea identificar
REGISTRO2     EQU       0x27	;Registro rutina de conversión BIN-BCD-Ascii
REGISTRO0     EQU       0x28    ;Registro rutina de conversión BIN-BCD-Ascii
REGISTRO1     EQU       0x29	;Registro rutina de conversión BIN-BCD-Ascii
H_BYTE        EQU       0x2A	;Registro rutina de conversión BIN-BCD-Ascii
L_BYTE        EQU       0x2B	;Registro rutina de conversión BIN-BCD-Ascii
CONTADOR      EQU       0x2C	;Registro rutina de conversión BIN-BCD-Ascii
TEMP          EQU       0x2D 	;Registro rutina de conversión BIN-BCD-Ascii
UNIDAD		  EQU       0x2E 	;Registro rutina de conversión BIN-BCD-Ascii
DECENA	      EQU       0x2F 	;Registro rutina de conversión BIN-BCD-Ascii
CENTENA	      EQU       0x30 	;Registro rutina de conversión BIN-BCD-Ascii
UNIDAD_MIL    EQU       0x31 	;Registro rutina de conversión BIN-BCD-Ascii
RESULTADO_H   EQU       0x32 	;Registro rutina de conversión BIN-BCD-Ascii
RESULTADO_L   EQU       0x33 	;Registro rutina de conversión BIN-BCD-Ascii
numeroA       EQU       0x34 	;Registro rutina de Delay
numeroB       EQU       0x35 	;Registro rutina de Delay
numeroC       EQU       0x36 	;Registro rutina de Delay
resultado     EQU       0x37 	;Registro rutina de Delay
CONTADOR2     EQU       0x38 	;Registro rutina de Delay

;Asignacion de los nombres de los vectores
VECTOR_RESET		EQU	0x00	; Vector de reset, aqui se dirigi el micro cada vez que inicia
VECTOR_INTERRUPCION	EQU	0x04	; Vector de interrupcion, aqui se dirigi el micro cada vez que existe una interrupcion

;Inicio del codigo
	ORG		VECTOR_RESET		; inicio del programa
	GOTO 	MAIN
	ORG		VECTOR_INTERRUPCION	;Que debe hacer el micro cuando hay una interrupcion
	GOTO	INTERRUPCION

;Subritinas utilizadas en este programa

CINCO_MICROSEGUNDOS
	MOVLW	D'22'	; Cargar este valor en W register (como valor Binario)
	MOVWF	CONTADOR2		; cargar el valor de W en numeroA
LOOP2					; Ciclo para esperar 5seg
	DECFSZ	CONTADOR2,f	
	GOTO	LOOP2
	RETURN

enviaRS232 ; Rutina de envío asincrono
	movwf TXREG             ; envío el dato en acunulador w
	bsf STATUS,RP0		; Pág 1 RAM
Espere 	
	btfss TXSTA,TRMT        ; transmision completa si es altoº
    goto Espere
    bcf STATUS,RP0          ; Pág 0 RAM
    return

msgCR ;Tecla Enter
	movlw 	0x0D
	call	enviaRS232
	movlw 	0x0A
	goto	enviaRS232

INICIO_ADC ;Rutina cuando la interrupciónse genera por RB0 por flanco de subida
	BSF ADCON0,ADON;Se inicia el modulo conversor analogo digital
	CALL CINCO_MICROSEGUNDOS ;Acquisiton delay
	BSF ADCON0,GO ;Start conversion
RETURN

;RUTINA DEL RUSO, NIKOLAI GOLOVCHENKO, adapatada por Nerio Montoya
;http://www.piclist.com/techref/member/ng--944/index.htm
;
;ESTE ES EL MODULO ENCARGADO DE TRANSFORMAR EL NUMERO BINARIO DE 10 BIT
;EN UN NUMERO BCD REPRESENTADO EN TRES REGISTROS DE 8 BIT, ESTOS REGISTROS
;SON REGISTRO# (0,1,2). POSTERIORMENTE DE TENER CREADOS LOS TRES REGISTROS
;SE CREA CADA UNO DE LOS NUMEROS A SER REPRESENTADOS (LOS CUALES SERAN 
;LUEGO CAMBIADOS A VALOR PARA DISPLAY)
;
;ESTE PROGRAMA DEBE LLAMAR A LOS REGISTRO ADRESSH Y ADRESSL, LOS CUALES 
;DEBEN SER CARGADOS EN LOS REGISTROS H_BYTE Y L_BYTE

TRANSF_BIN_BCD

	;CALL	MATEMATICAS		;ESTA SUBRUTINA ES LLAMADA PARA ADECUAR EL DATO A LA ESCALA BINARIA QUE SE TIENE
	CLRF    REGISTRO0		;REINICIAR EL REGISTRO
	CLRF    REGISTRO1		;REINICIAR EL REGISTRO
	CLRF    REGISTRO2		;REINICIAR EL REGISTRO
	CLRF    UNIDAD          ;REINICIAR EL REGISTRO
	CLRF    DECENA          ;REINICIAR EL REGISTRO
	CLRF    CENTENA         ;REINICIAR EL REGISTRO
	CLRF    UNIDAD_MIL      ;REINICIAR EL REGISTRO
	
	MOVF	RESULTADO_H,W	;CARGAR EL REGISTRO RESULTADO DEL ACONDICIONALMIENTO DEL DATO
	;MOVLW	B'00000100'		;VALOR PARA HACER PRUEBAS
	BANKSEL H_BYTE
	MOVWF	H_BYTE			;PARA SER TRANSFORMADO Y POSTERIORMENTE PRESENTADO
	BANKSEL	RESULTADO_L
	MOVF	RESULTADO_L,W	;CARGAR EL REGISTRO RESULTADO DEL ACONDICIONALMIENTO DEL DATO
	;MOVLW	B'11100010'		;VALOR PARA HACER PRUEBAS
	BANKSEL L_BYTE
	MOVWF	L_BYTE			;PARA SER TRANSFORMADO Y POSTERIORMENTE PRESENTADO

	BCF     STATUS,C		;BORRA EL REGISTRO CARRY
	MOVLW   0x10			;ESTE ES EL VALOR DEL CONTADOR PARA EL PROCESO DE CONVERSION
	MOVWF   CONTADOR		;MOVER EL VALOR (16) AL REGISTRO CONTADOR
	GOTO	LOOP			;IR A LA RUTINA DE CONVERSION

LOOP
	RLF     L_BYTE,F		;RUTINA DE CONVERSION, DESCARGADA DE INTERNET... 	
	RLF     H_BYTE,F		;FUNCIONA AUNQUE NO LA ENTIENDO
	RLF     REGISTRO2,F
	RLF     REGISTRO1,F
	RLF     REGISTRO0,F
	DECFSZ  CONTADOR,F
	GOTO    ADJ_DEC
	GOTO	CREAR_REGISTROS
	NOP
	RETURN

ADJ_DEC
	MOVLW   REGISTRO2
	MOVWF   FSR
	CAll    ADJ_BCD
	MOVLW   REGISTRO1
	MOVWF   FSR
	CAll    ADJ_BCD
	MOVLW   REGISTRO0
	MOVWF   FSR
	CAll    ADJ_BCD
	GOTO    LOOP

ADJ_BCD
	MOVLW   3
	ADDWF   INDF,W
	MOVWF   TEMP
	BTFSC   TEMP,3          
	MOVWF   INDF
	MOVLW   30
	ADDWF   INDF,W
	MOVWF   TEMP
	BTFSC   TEMP,7          
	MOVWF   INDF            
	RETURN
	
;ESTA ES LA RUTINA QUE CREA LOS VALORES DIGITALES EXTRAIDOS DE LOS REGISTROS#
;EN ESTA RUTINA SE CREAN 5 REGISTROS, CADA RESGISTRO ES UN NUMERO.
CREAR_REGISTROS
	MOVF	REGISTRO2,W
	ANDLW	0x0F
	MOVWF	UNIDAD
	SWAPF	REGISTRO2,W
	ANDLW	0x0F
	MOVWF	DECENA
	
	MOVF	REGISTRO1,W
	ANDLW	0x0F
	MOVWF	CENTENA
	SWAPF	REGISTRO1,W
	ANDLW	0x0F
	MOVWF	UNIDAD_MIL
	
	;MOVF	REGISTRO0,W
	;ANDLW	0x0F
	;MOVWF	UNIDAD_DIEZMIL
	RETURN    ;De aquí se sale de la Rutina

OBTENER_#ARAB
	ADDWF	PCL
	RETLW	D'48'		;ESCRIBIR 0 VIA SERIAL -> CODIFO ASCII
	RETLW	D'49'		;ESCRIBIR 1 VIA SERIAL -> CODIFO ASCII
	RETLW	D'50'		;ESCRIBIR 2 VIA SERIAL -> CODIFO ASCII
	RETLW	D'51'		;ESCRIBIR 3 VIA SERIAL -> CODIFO ASCII
	RETLW	D'52'		;ESCRIBIR 4 VIA SERIAL -> CODIFO ASCII
	RETLW	D'53'		;ESCRIBIR 5 VIA SERIAL -> CODIFO ASCII
	RETLW	D'54'		;ESCRIBIR 6 VIA SERIAL -> CODIFO ASCII
	RETLW	D'55'		;ESCRIBIR 7 VIA SERIAL -> CODIFO ASCII
	RETLW	D'56'		;ESCRIBIR 8 VIA SERIAL -> CODIFO ASCII
	RETLW	D'57'		;ESCRIBIR 9 VIA SERIAL -> CODIFO ASCII

; -- Manejo de las interrupciones, esto es tema de unas clases mas adelante
INTERRUPCION 
    movwf   w_saved        ; guardar contexto
    swapf   STATUS,w
    movwf   status_saved
    movf    PCLATH,w       ; solamente se requiere si se utiliza mÃ¡s de la primera pÃ¡gina
    movwf   pclath_saved
    clrf    PCLATH

	BTFSC PIR1,ADIF ;Verificar si es la interrupcion por Conversion completa
	GOTO RECEPCION
	RETFIE ; No es ninguna de ellas, entonces salga.


RECEPCION ;Acoplamiento de la señal que se convirtio
	BANKSEL ADCON0
	BCF ADCON0,GO
	BCF ADCON0,ADON
	BANKSEL ADRESL
	MOVF  ADRESL,W
	BANKSEL RESULTADO_L
	MOVWF RESULTADO_L
	BANKSEL ADRESH
	MOVF  ADRESH,W
	MOVWF RESULTADO_H
	CALL TRANSF_BIN_BCD ;trasformar en 4 registros los binarios de cada uno de los numeros de la conversión analoga digital
	MOVF UNIDAD_MIL,0
	CALL OBTENER_#ARAB
	CALL enviaRS232
	MOVF CENTENA,0
	CALL OBTENER_#ARAB
	CALL enviaRS232
	MOVF DECENA,0
	CALL OBTENER_#ARAB
	CALL enviaRS232
	MOVF UNIDAD,0
	CALL OBTENER_#ARAB
	CALL enviaRS232
	CALL msgCR
	CALL INICIO_ADC
    GOTO SALIDA

SALIDA
	BCF PIR1,ADIF ;Borra la bandera para que hayan mas interrupciones
	movf    pclath_saved,w ; restaurar contexto
    movwf   PCLATH
    swapf   status_saved,w
    movwf   STATUS
    swapf   w_saved,f
    swapf   w_saved,w
    retfie
; -- Fin del manejo de las interrupciones

; ** Aqui comienza el codigo principal del programa **
MAIN
	;Configuración de los puertos
	BANKSEL ANSELH
	MOVLW B'00000000'; Todos los pines son digitales
	MOVWF ANSELH
	BANKSEL TRISB ; Me voy para el banco del trisb y del optioenReg
	MOVLW B'00000001'; Todos los pines son salidas menos el primero que es entrada
	MOVWF TRISB ;Lo meto en este registro
	BCF TRISC,6 ;Salida, este es el TX
	BSF TRISC,7 ;Entrada, éste es el RX
	BSF OPTREG,6 ;Interrupción por flanco de subida del RB0 o INT0
	BANKSEL PORTB ;Me voy para el banco del puerto b
	;Configuración de las interrupciones
	BSF INTCON,GIE ;La que se tiene que habilitar siempre que se trabaje con al menos una interrupción
	BSF INTCON,PEIE ;Esta es la de interrupciones perifericas (Necesaria si se trabaja con interrupcion por recepción).
	;Configuración de la comunicaciòn
	;definiciones para USART
	;Baud Rate = 9600, Sin Paridad, 1 Bit parada
    BANKSEL SPBRG ;Se carga el 520 en estos dos registros
	movlw B'00001000'
    movwf SPBRG
	BANKSEL SPBRGH
	movlw B'00000010'
    movwf SPBRGH	
    BANKSEL TXSTA ;Nos ubicamos en el banco de este registro TXSTA
	movlw b'00100110' 
    movwf TXSTA    ; habilita la transmisión Async;
	BANKSEL RCSTA
    movlw b'10010000'       
    movwf RCSTA  ; habilita de recepción Async
	banksel BAUDCTL ;Nos ubicamos en el banco de este registro BAUDCTL
	BSF BAUDCTL,BRG16 ;Habilitamos calculo de la velocidad con registro de 16 bits, para mayor precisión
	BANKSEL PIE1 ;Nos ubicamos en el banco de este registro PIE1
	BCF PIE1,4 ; Sin interrupcion por transmición
	BCF PIE1,5 ;son interrupción por recepción
	
	;Configuración de la conversión analoga-digital
	BANKSEL ADCON1 ;
	MOVLW B'10110000' ;right justify
	MOVWF ADCON1 ;Vdd and Vss as Vref
	BANKSEL TRISA ;
	BSF TRISA,0 ;Set RA0 to input
	BSF TRISA,2
	BSF TRISA,3

	BANKSEL ANSEL ;
	BSF ANSEL,0 ;Set RA0 to analog
	BSF ANSEL,3
	BSF ANSEL,2
	BANKSEL ADCON0 ;
	CLRF ADCON0
	BSF ADCON0,7 ;Selección del reloj de la conversión
	
	BANKSEL PIE1 
	BSF PIE1,ADIE ;Habilitar interrupcion por conversion completa
	BANKSEL PIR1
	BCF PIR1,ADIF ; Bajar la bandera

	BANKSEL PORTB ;Volvemos al banco cero

    movf RCREG,W            ; vacía el buffer de recepción

	;Se envía un mensaje de bienvenida "Junior"
	MOVLW 'J' ;Cargo el Ascii de la letra J
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'u' ;Cargo el Ascii de la letra u
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'n' ;Cargo el Ascii de la letra n
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'i' ;Cargo el Ascii de la letra i
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'o' ;Cargo el Ascii de la letra o
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'r' ;Cargo el Ascii de la letra r
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	CALL msgCR ; Rutina del Ascii del Enter
	CALL INICIO_ADC
	GOTO $ ;Espera interrupción por RB0 o por RCREG

	END  

