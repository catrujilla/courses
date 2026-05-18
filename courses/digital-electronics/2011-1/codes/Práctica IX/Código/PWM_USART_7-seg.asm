
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;PWM_USART_7-seg.c,10 :: 		void interrupt() {
;PWM_USART_7-seg.c,11 :: 		if (PIR1.RCIF) {
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt0
;PWM_USART_7-seg.c,12 :: 		led = UART1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _led+0
;PWM_USART_7-seg.c,14 :: 		if (led=='A') {
	MOVF       R0+0, 0
	XORLW      65
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;PWM_USART_7-seg.c,15 :: 		if (estado_PWM==1){
	MOVLW      0
	XORWF      _estado_PWM+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt11
	MOVLW      1
	XORWF      _estado_PWM+0, 0
L__interrupt11:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;PWM_USART_7-seg.c,16 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;PWM_USART_7-seg.c,17 :: 		estado_PWM = 0;
	CLRF       _estado_PWM+0
	CLRF       _estado_PWM+1
;PWM_USART_7-seg.c,18 :: 		goto salir;
	GOTO       ___interrupt_salir
;PWM_USART_7-seg.c,19 :: 		}
L_interrupt2:
;PWM_USART_7-seg.c,20 :: 		if (estado_PWM==0){
	MOVLW      0
	XORWF      _estado_PWM+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt12
	MOVLW      0
	XORWF      _estado_PWM+0, 0
L__interrupt12:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;PWM_USART_7-seg.c,21 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;PWM_USART_7-seg.c,22 :: 		estado_PWM = 1;
	MOVLW      1
	MOVWF      _estado_PWM+0
	MOVLW      0
	MOVWF      _estado_PWM+1
;PWM_USART_7-seg.c,23 :: 		}
L_interrupt3:
;PWM_USART_7-seg.c,37 :: 		salir:
___interrupt_salir:
;PWM_USART_7-seg.c,38 :: 		asm nop;
	NOP
;PWM_USART_7-seg.c,39 :: 		}
L_interrupt1:
;PWM_USART_7-seg.c,40 :: 		PIR1.RCIF = 0;  //sALGA DE ESTA INTERRUPCIÓN
	BCF        PIR1+0, 5
;PWM_USART_7-seg.c,41 :: 		}
L_interrupt0:
;PWM_USART_7-seg.c,42 :: 		}
L__interrupt10:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;PWM_USART_7-seg.c,44 :: 		void main() {
;PWM_USART_7-seg.c,45 :: 		ANSEL  = 0x04;              // Configure AN2 pin as analog
	MOVLW      4
	MOVWF      ANSEL+0
;PWM_USART_7-seg.c,46 :: 		TRISA  = 0xFF;              // PORTA is input
	MOVLW      255
	MOVWF      TRISA+0
;PWM_USART_7-seg.c,47 :: 		ANSELH = 0;                 // Configure other AN pins as digital I/O
	CLRF       ANSELH+0
;PWM_USART_7-seg.c,48 :: 		TRISB  = 0x00;              // Salidas
	CLRF       TRISB+0
;PWM_USART_7-seg.c,49 :: 		TRISC.RC1 = 0;
	BCF        TRISC+0, 1
;PWM_USART_7-seg.c,50 :: 		PORTC.RC1 = 0;
	BCF        PORTC+0, 1
;PWM_USART_7-seg.c,51 :: 		PORTB  = 0x00;
	CLRF       PORTB+0
;PWM_USART_7-seg.c,52 :: 		INTCON = 0B11000000;        //Sólo GIE y PIE
	MOVLW      192
	MOVWF      INTCON+0
;PWM_USART_7-seg.c,53 :: 		UART1_Init(115200);
	MOVLW      10
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;PWM_USART_7-seg.c,54 :: 		PIE1.RCIE = 1;               //aCTIVA iNTERRUPCIÓN POR RECEPCION
	BSF        PIE1+0, 5
;PWM_USART_7-seg.c,55 :: 		delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main4:
	DECFSZ     R13+0, 1
	GOTO       L_main4
	DECFSZ     R12+0, 1
	GOTO       L_main4
	DECFSZ     R11+0, 1
	GOTO       L_main4
	NOP
	NOP
;PWM_USART_7-seg.c,57 :: 		PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;PWM_USART_7-seg.c,58 :: 		current_duty  = 127;                 // initial value for current_duty 50%
	MOVLW      127
	MOVWF      _current_duty+0
;PWM_USART_7-seg.c,59 :: 		PWM1_Start();                       // start PWM1
	CALL       _PWM1_Start+0
;PWM_USART_7-seg.c,60 :: 		PWM1_Set_Duty(current_duty);        // Set current duty for PWM1
	MOVF       _current_duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;PWM_USART_7-seg.c,62 :: 		estado_PWM = 1;
	MOVLW      1
	MOVWF      _estado_PWM+0
	MOVLW      0
	MOVWF      _estado_PWM+1
;PWM_USART_7-seg.c,64 :: 		do {
L_main5:
;PWM_USART_7-seg.c,65 :: 		temp_res = ADC_Read(2);   // Get 10-bit results of AD conversion
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_res+0
	MOVF       R0+1, 0
	MOVWF      _temp_res+1
;PWM_USART_7-seg.c,67 :: 		voltaje_mV = temp_res*(4.88758);
	CALL       _Word2Double+0
	MOVLW      14
	MOVWF      R4+0
	MOVLW      103
	MOVWF      R4+1
	MOVLW      28
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _Double2Word+0
	MOVF       R0+0, 0
	MOVWF      _voltaje_mV+0
	MOVF       R0+1, 0
	MOVWF      _voltaje_mV+1
;PWM_USART_7-seg.c,68 :: 		IntToStr(voltaje_mV,txt);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;PWM_USART_7-seg.c,69 :: 		UART1_Write_Text(txt),UART1_Write_Text("mV"),UART1_Write(10),UART1_Write(13) ;
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      ?lstr1_PWM_USART_7_45seg+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;PWM_USART_7-seg.c,71 :: 		long_current_duty = ((12.14)*temp_res) - 485.7142;
	MOVF       _temp_res+0, 0
	MOVWF      R0+0
	MOVF       _temp_res+1, 0
	MOVWF      R0+1
	CALL       _Word2Double+0
	MOVLW      113
	MOVWF      R4+0
	MOVLW      61
	MOVWF      R4+1
	MOVLW      66
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      107
	MOVWF      R4+0
	MOVLW      219
	MOVWF      R4+1
	MOVLW      114
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	CALL       _Double2Longint+0
	MOVF       R0+0, 0
	MOVWF      _long_current_duty+0
	MOVF       R0+1, 0
	MOVWF      _long_current_duty+1
	MOVF       R0+2, 0
	MOVWF      _long_current_duty+2
	MOVF       R0+3, 0
	MOVWF      _long_current_duty+3
;PWM_USART_7-seg.c,72 :: 		if (long_current_duty<0) long_current_duty=0;
	MOVLW      128
	XORWF      R0+3, 0
	MOVWF      R4+0
	MOVLW      128
	SUBWF      R4+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVLW      0
	SUBWF      R0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVLW      0
	SUBWF      R0+0, 0
L__main13:
	BTFSC      STATUS+0, 0
	GOTO       L_main8
	CLRF       _long_current_duty+0
	CLRF       _long_current_duty+1
	CLRF       _long_current_duty+2
	CLRF       _long_current_duty+3
L_main8:
;PWM_USART_7-seg.c,73 :: 		if (long_current_duty>255) long_current_duty=255;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _long_current_duty+3, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main14
	MOVF       _long_current_duty+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main14
	MOVF       _long_current_duty+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main14
	MOVF       _long_current_duty+0, 0
	SUBLW      255
L__main14:
	BTFSC      STATUS+0, 0
	GOTO       L_main9
	MOVLW      255
	MOVWF      _long_current_duty+0
	CLRF       _long_current_duty+1
	CLRF       _long_current_duty+2
	CLRF       _long_current_duty+3
L_main9:
;PWM_USART_7-seg.c,74 :: 		current_duty = long_current_duty;
	MOVF       _long_current_duty+0, 0
	MOVWF      _current_duty+0
;PWM_USART_7-seg.c,75 :: 		PWM1_Set_Duty(current_duty);        // Set current duty for PWMM
	MOVF       _long_current_duty+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;PWM_USART_7-seg.c,77 :: 		} while(1);
	GOTO       L_main5
;PWM_USART_7-seg.c,78 :: 		}
	GOTO       $+0
; end of _main
