
	list		p=16f883	; list directive to define processor
	#include	<p16f883.inc>	; processor specific variable definitions

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _HS_OSC
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

;***** VARIABLE DEFINITIONS
w_temp		EQU	0x7D		; variable used for context saving
status_temp	EQU	0x7E		; variable used for context saving
pclath_temp	EQU	0x7F		; variable used for context saving

OPTREG   	  EQU    	0x81	; Dirrección del OPTION_REG
caracter      EQU		0X26	; Registro que contiene el Ascii de la letra que se desea identificar

;**********************************************************************
	ORG     0x000             ; processor reset vector

	NOP
  	GOTO    main              ; go to beginning of program


	ORG     0x004             ; interrupt vector location

INTERRUPCION

	movwf   w_temp            ; save off current W register contents
	movf	STATUS,w          ; move status register into W register
	movwf	status_temp       ; save off contents of STATUS register
	movf	PCLATH,w	  ; move pclath register into w register
	movwf	pclath_temp	  ; save off contents of PCLATH register

	BTFSC INTCON,INTF ;Verificar si es la Interrupcion RB0
	GOTO MANEJO_INTERRUPCION
	BTFSC PIR1,RCIF ;Verificar si es la interrupcion por Recepción
	GOTO RECEPCION
	GOTO SALIR_INT

MANEJO_INTERRUPCION ;
	MOVLW 'C' ;Cargo el Ascii de la letra C
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'a' ;Cargo el Ascii de la letra a
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'r' ;Cargo el Ascii de la letra r
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'l' ;Cargo el Ascii de la letra l
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'o' ;Cargo el Ascii de la letra o
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 's' ;Cargo el Ascii de la letra s
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	CALL msgCR ;Rutina del Ascii de la tecla Enter
	GOTO SALIR_INT ;Salimos de la Interrupción

RECEPCION ;Recepción y lógica del dato que llega
    MOVF RCREG,W            ; guarda dato recibido en acumulador 
    SUBWF caracter,0 ;Se sustrae lo que está en w (el Ascii de la letra que se presionó) menos el caracter previamente determinado.
DECISION
	BTFSS STATUS,0 ;Si la resta es cero, tanto el Bit 0 como el Bit 2 del STATUS serán 1.
	GOTO teclaErrada ;No es la letra predeterminada, vaya y muestre eso
	BTFSS STATUS,2
	GOTO teclaErrada ;No es la letra predeterminada, vaya y muestre eso
	GOTO teclacorrecta ;Si es la letra predeterminada; Muestre eso.

teclacorrecta ;Lógica que cambia el estado de RB1, si la tecla que se undió es la predeterminada.
	BTFSS PORTB,1
	GOTO PRENDER
	GOTO APAGAR
PRENDER
	BSF PORTB,1
	GOTO SALIR_INT
APAGAR
	BCF PORTB,1
	GOTO SALIR_INT

teclaErrada ;Lógica que cambia el estado del RB2, si la tecla que se presionó no es la predeterminada
	BTFSS PORTB,2
	GOTO PRENDER1
	GOTO APAGAR1
PRENDER1
	BSF PORTB,2
	GOTO SALIR_INT
APAGAR1
	BCF PORTB,2
	GOTO SALIR_INT

	SALIR_INT
	BCF INTCON,INTF ;Borra la bandera para que hayan mas interrupciones
	BCF PIR1,RCIF   ;Borra la bandera para que hayan mas interrupciones
	movf	pclath_temp,w	  ; retrieve copy of PCLATH register
	movwf	PCLATH		  ; restore pre-isr PCLATH register contents
	movf    status_temp,w     ; retrieve copy of STATUS register
	movwf	STATUS            ; restore pre-isr STATUS register contents
	swapf   w_temp,f
	swapf   w_temp,w          ; restore pre-isr W register contents
	retfie                    ; return from interrupt

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

main
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
	BSF INTCON,INTE ;Esta es la de la INTE
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
	BSF PIE1,5 ;Con interrupción por recepción
	BANKSEL PORTB ;Volvemos al banco cero
	
	;mensaje de bienvenida:
	MOVLW 'C' ;Cargo el Ascii de la letra C
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'a' ;Cargo el Ascii de la letra a
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'r' ;Cargo el Ascii de la letra r
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'l' ;Cargo el Ascii de la letra l
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 'o' ;Cargo el Ascii de la letra o
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	MOVLW 's' ;Cargo el Ascii de la letra s
	CALL enviaRS232 ;Llamo rutina de envio de dato que está en el acumulador w
	CALL msgCR ;Rutina del Ascii de la tecla Enter
	MOVLW 'g' ;Cargar el valor del ascii de la "g" en el registro caracter
				;el cual se compara con la tecla presionada para tomar una decisión
	MOVWF caracter

	GOTO $ ;Espera interrupción por RB0 o por RCREG

	END                       ; directive 'end of program'