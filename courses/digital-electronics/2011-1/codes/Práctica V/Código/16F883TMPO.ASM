;**********************************************************************
;   This file is a basic code template for object module code         *
;   generation on the PIC16F883. This file contains the               *
;   basic code building blocks to build upon.                         *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler and linker (Document DS33014).          *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:     interrupciones.asm                                           *
;    Date:         3 de Marzo de 2011                                                   *
;    File Version: 1.0                                                   *
;                                                                     *
;    Author:       Carlos Trujillo	                                                   *
;    Company:      Familia                                                   *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files required: P16F883.INC                                      *
;                                                                     *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:    Este programa permite por medio de las interrupciones  *
;              del puerto B y del Timer0 controlar el funcionamiento  *
;               del PIC.                                              *
;                                                                     *
;                                                                     *
;**********************************************************************

    list        p=16f883    ; list directive to define processor
    #include    <p16f883.inc>   ; processor specific variable definitions

; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

    __CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _HS_OSC
    __CONFIG    _CONFIG2, _WRT_OFF & _BOR21V

;***** VARIABLE DEFINITIONS (examples)
OPTREG   	EQU    	0x81	; Dirrección del OPTION_REG
CONTADOR	EQU		0X24	; Asignacion de nombre resultado al resgistro 0x24

; example of using Shared Uninitialized Data Section
INT_VAR     UDATA_SHR   
w_temp      RES     1       ; variable used for context saving
status_temp RES     1       ; variable used for context saving
pclath_temp RES     1       ; variable used for context saving

; example of using Uninitialized Data Section
TEMP_VAR    UDATA           ; explicit address specified is not required
temp_count  RES     1       ; temporary variable (example)

;**********************************************************************
RESET_VECTOR    CODE    0x0000  ; processor reset vector
    nop
    goto    start               ; go to beginning of program

INT_VECTOR      CODE    0x0004  ; interrupt vector location

INTERRUPT

    movwf   w_temp          ; save off current W register contents
    movf    STATUS,w        ; move status register into W register
    movwf   status_temp     ; save off contents of STATUS register
    movf    PCLATH,w        ; move pclath register into w register
    movwf   pclath_temp     ; save off contents of PCLATH register

	BTFSC INTCON,T0IF
	GOTO MANEJO_INTERRUPCION_TIMER0
	BTFSC INTCON,INTF
	GOTO MANEJO_INTERRUPCION_RBO
	BTFSC INTCON,RBIF
	GOTO MANEJO_INTERRUPCION_CHANGE
	GOTO SALIDA_RBCHANGE ; Salir guardando el contexto
	
MANEJO_INTERRUPCION_TIMER0
	DECFSZ CONTADOR,1
	GOTO SALIDA_TIMER0
ESTADO
	BTFSC PORTA,3
	GOTO APAGAR
	GOTO PRENDER

APAGAR
	BCF PORTA,3
	GOTO NEWCONTEO

PRENDER
	BSF PORTA,3
	GOTO NEWCONTEO

NEWCONTEO
	BANKSEL PORTB ;Me voy para el banco del puerto b
	MOVLW d'152'
	MOVWF CONTADOR
	GOTO SALIDA_TIMER0

SALIDA_TIMER0
	BCF INTCON,2 ;Borra la bandera para que hayan mas interrupciones
	GOTO SALIDA_RBCHANGE ; Salir guardando el contexto

MANEJO_INTERRUPCION_RBO
	BTFSC PORTA,2
	GOTO APAGAR2
	GOTO PRENDER2

APAGAR2
	BCF PORTA,2
	GOTO SALIDA_RB0

PRENDER2
	BSF PORTA,2
	GOTO SALIDA_RB0

SALIDA_RB0
	BCF INTCON,1 ;Borra la bandera para que hayan mas interrupciones
	GOTO SALIDA_RBCHANGE ; Salir guardando el contexto

MANEJO_INTERRUPCION_CHANGE
	BTFSC PORTB,4
	GOTO PIN4
	BTFSC PORTB,5
	GOTO PIN5
	BTFSC PORTB,6
	GOTO PIN6
	BTFSC PORTB,7
	GOTO PIN7
	GOTO SALIDA_RBCHANGE; vA DIRECTAMENTE ALA SALIDA , YA QUE NO HAY NADIE UNDIDO

PIN4
	MOVLW B'01010101'
	MOVWF PORTC
	GOTO SALIDA_RBCHANGE
PIN5
	MOVLW B'00001111'
	MOVWF PORTC
	GOTO SALIDA_RBCHANGE
PIN6
	MOVLW B'11001100'
	MOVWF PORTC
	GOTO SALIDA_RBCHANGE
PIN7
	MOVLW B'11000011'
	MOVWF PORTC
	GOTO SALIDA_RBCHANGE

SALIDA_RBCHANGE
	BCF INTCON,0 ;Borra la bandera para que hayan mas interrupciones
    movf    pclath_temp,w   ; retrieve copy of PCLATH register
    movwf   PCLATH          ; restore pre-isr PCLATH register contents
    movf    status_temp,w   ; retrieve copy of STATUS register
    movwf   STATUS          ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w        ; restore pre-isr W register contents
	RETFIE		; No se hace nada, solo se retorna y se activan las interrupciones globales	
; -- Fin del manejo de las interrupciones 

MAIN_PROG       CODE

start

	;Configuración de los puertos
	BANKSEL ANSELH
	MOVLW B'00000000'; Todos los pines son salidas
	MOVWF ANSELH
	BANKSEL ANSEL
	MOVLW B'00000000'; Todos los pines son salidas
	MOVWF ANSEL
	BANKSEL TRISB ; Me voy para el banco del trisb y del optioenReg
	MOVLW B'11110001'; Todos los pines son salidas
	MOVWF TRISB ;Lo meto en este registro
	MOVLW B'00000000'; Todos los pines son salidas
	MOVWF TRISC
	MOVLW B'00000000'; Todos los pines son salidas
	MOVWF TRISA
	MOVLW B'11110000'; Todos los pines son salidas
	MOVWF IOCB
	MOVLW  B'01000111' ;TIMER0 PRESCALER 1:256
	MOVWF  OPTREG
	BANKSEL PORTB ;Me voy para el banco del puerto b
	MOVLW B'00000000'; Todos los pines son salidas
	MOVWF PORTC
	MOVLW d'152'
	MOVWF CONTADOR
	;Configuración de las interrupciones
	MOVLW B'11111000';Habilitar todas las interrupciones
	MOVWF INTCON
	CLRF TMR0
	;A la espera del desborde
	GOTO $


    END                     ; directive 'end of program'