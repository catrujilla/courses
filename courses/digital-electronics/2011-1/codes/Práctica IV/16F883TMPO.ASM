;**********************************************************************
;                                                                     *
;    Filename:     Práctica 1                                           *
;    Date:         Marzo 1 de 2011                                                   *
;    File Version: 1.0.                                                   *
;                                                                     *
;    Author:       Carlos A Trujillo Anaya                                                   *
;    Company:      Universidad Nacional de Colombia                                                   *
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
;    Notes:   Este programa cada dos segundos verifica el estado de                                                         *
;             un pin y establece el estado de un puerto a partir del                                                        *
;             pin.                                                        *
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
numeroA		equ 0x21	; Asignacion de nombre numeroA al resgistro 0x21
numeroB		equ 0x22	; Asignacion de nombre numeroB al resgistro 0x22
resultado	equ 0x23	; Asignacion de nombre resultado al resgistro 0x23
numeroC		equ 0x24	; Asignacion de nombre resultado al resgistro 0x24


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
    goto    Inicio               ; go to beginning of program

INT_VECTOR      CODE    0x0004  ; interrupt vector location

Interrupcion

    movwf   w_temp          ; save off current W register contents
    movf    STATUS,w        ; move status register into W register
    movwf   status_temp     ; save off contents of STATUS register
    movf    PCLATH,w        ; move pclath register into w register
    movwf   pclath_temp     ; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere

    movf    pclath_temp,w   ; retrieve copy of PCLATH register
    movwf   PCLATH          ; restore pre-isr PCLATH register contents
    movf    status_temp,w   ; retrieve copy of STATUS register
    movwf   STATUS          ; restore pre-isr STATUS register contents
    swapf   w_temp,f
    swapf   w_temp,w        ; restore pre-isr W register contents
    retfie                  ; return from interrupt

;Rutina de espera de 2 segundos
Cinco_Segundos
	NOP					;Esta intruccion no hace nada...
	MOVLW	D'255'	; Cargar este valor en W register (como valor Binario)
	MOVWF	numeroA		; cargar el valor de W en numeroA
	MOVLW	D'240'	; Cargar este valor en W register (como valor Binario)
	MOVWF	resultado		; cargar el valor de W en numeroA
	MOVLW	D'0'
    MOVWF	numeroB		; cargar el valor de W en numeroB
	MOVLW	D'192'
	MOVWF	numeroC		; cargar el valor de W en numeroC
    NOP
LOOP1					; Ciclo para esperar 5seg
	DECFSZ	numeroA,f	
	GOTO	LOOP1
	NOP			
	BSF		numeroA,1	
	INCFSZ	numeroB,f	
    GOTO	LOOP1		
	INCFSZ	numeroC,f
    GOTO	LOOP1
    INCFSZ	resultado,f
    GOTO	LOOP1
	RETURN

;Decidimos si el pulser está pulsado o no
DECISION
	BTFSC   PORTB,1 ; Testea si está prendido o apagado.
	Goto PRENDER2 ;Prende
	Goto APAGAR2 ;Apaga
	
PRENDER2
	MOVLW B'11111111' ;255 EN W
	MOVWF PORTC		  ;Lo pongo en puerto C
	RETURN  ;vuelve

APAGAR2
	MOVLW d'0' ;0 EN W
	MOVWF PORTC		  ;Lo pongo en puerto C
	RETURN ;vuelve


MAIN_PROG       CODE

Inicio

	BANKSEL ANSELH  ; Me voy para el banco del ANSELH
	MOVLW B'00000000'; Todos los pines son digitales
	MOVWF ANSELH  ;Lo meto en este registro
	BANKSEL TRISB ; Me voy para el banco del trisb
	MOVLW B'00000010'; Todos los pines son salidas, excepto RB1
	MOVWF TRISB ;Lo meto en este registro
	MOVLW D'0'
	MOVWF TRISC ;Lo meto en este registro
	BANKSEL PORTB ;Me voy para el banco del puerto b
	CLRF PORTB ;Borro el puerto
	CLRF PORTC  ;Borro el puerto

Principal	
	CALL Cinco_Segundos ;invoco Rutina
	CALL DECISION		;invoco Rutina
	GOTO Principal		;Ciclo principal del programa

	END 