; -----------------------------------------------------------------------
; Plantilla generada por Piklab
    #include <p16f883.inc> ;Formato de include en Piklab <-> GPutils
; -----------------------------------------------------------------------
;Codigo general para programacion de un micro.
;Lo mas fundamental de este codigo es la grabacion del contexto en el que
;se encontraba el microcontrolador antes de atender la interrupcion.
;Ver numeral 14.4 para mayor informacion.
; -----------------------------------------------------------------------
; Bits de configuración: adapte los parámetros a su necesidad
    __CONFIG _CONFIG1, _EXTRC_OSC_CLKOUT & _WDT_ON & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_ON & _IESO_ON & _FCMEN_ON & _LVP_ON & _DEBUG_OFF
    __CONFIG _CONFIG2, _BOR40V & _WRT_OFF

; -----------------------------------------------------------------------
; Declaración de variables
INT_VAR UDATA_SHR
w_saved      RES 1 ; variable utilizada para guardar contexto
status_saved RES 1 ; variable utilizada para guardar contexto
pclath_saved RES 1 ; variable utilizada para guardar contexto

var1         RES 1 ; variable de ejemplo

; -----------------------------------------------------------------------
; reiniciar vector
STARTUP CODE 0x000
    nop                    ; requerido para el depurado ICD2
    movlw   high start     ; cargar el byte superior de la etiqueta «start»
    movwf   PCLATH         ; inicializar PCLATH
    goto    start          ; ir al inicio del código principal

; vector de interrupciones
INT_VECTOR CODE 0x004
    goto    interrupt      ; ir al inicio del código de interrupción

; código reubicable
PROG CODE
interrupt
    movwf   w_saved        ; guardar contexto
    swapf   STATUS,w
    movwf   status_saved
    movf    PCLATH,w       ; solamente se requiere si se utiliza más de la primera página
    movwf   pclath_saved
    clrf    PCLATH
    ; << agregue el código de interrupción >>
    movf    pclath_saved,w ; restaurar contexto
    movwf   PCLATH
    swapf   status_saved,w
    movwf   STATUS
    swapf   w_saved,f
    swapf   w_saved,w
    retfie

start
    ; << agregue el código principal >>
    goto    $              ; bucle infinito

END
