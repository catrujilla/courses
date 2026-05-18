
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ADC_USART_INT_TMRX.c,6 :: 		void interrupt() {
;ADC_USART_INT_TMRX.c,7 :: 		if (INTCON.TMR0IF) {
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;ADC_USART_INT_TMRX.c,8 :: 		contador_TMR0++;
	MOVF       _contador_TMR0+0, 0
	MOVWF      R0+0
	MOVF       _contador_TMR0+1, 0
	MOVWF      R0+1
	MOVF       _contador_TMR0+2, 0
	MOVWF      R0+2
	MOVF       _contador_TMR0+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _contador_TMR0+0
	MOVF       R0+1, 0
	MOVWF      _contador_TMR0+1
	MOVF       R0+2, 0
	MOVWF      _contador_TMR0+2
	MOVF       R0+3, 0
	MOVWF      _contador_TMR0+3
;ADC_USART_INT_TMRX.c,9 :: 		if (contador_TMR0 == desbordes){
	MOVF       _contador_TMR0+3, 0
	XORWF      _desbordes+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt32
	MOVF       _contador_TMR0+2, 0
	XORWF      _desbordes+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt32
	MOVF       _contador_TMR0+1, 0
	XORWF      _desbordes+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt32
	MOVF       _contador_TMR0+0, 0
	XORWF      _desbordes+0, 0
L__interrupt32:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;ADC_USART_INT_TMRX.c,10 :: 		envio_ADC = 1;
	MOVLW      1
	MOVWF      _envio_ADC+0
;ADC_USART_INT_TMRX.c,11 :: 		contador_TMR0 = 0;
	CLRF       _contador_TMR0+0
	CLRF       _contador_TMR0+1
	CLRF       _contador_TMR0+2
	CLRF       _contador_TMR0+3
;ADC_USART_INT_TMRX.c,12 :: 		}
L_interrupt1:
;ADC_USART_INT_TMRX.c,13 :: 		INTCON.TMR0IF = 0;
	BCF        INTCON+0, 2
;ADC_USART_INT_TMRX.c,14 :: 		}
	GOTO       L_interrupt2
L_interrupt0:
;ADC_USART_INT_TMRX.c,15 :: 		else if (INTCON.RBIF) {
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt3
;ADC_USART_INT_TMRX.c,16 :: 		if (PORTB.RB6 ==1) desbordes=desbordes+488;  //488 desbordes son 50ms
	BTFSS      PORTB+0, 6
	GOTO       L_interrupt4
	MOVLW      232
	MOVWF      R0+0
	MOVLW      1
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       _desbordes+0, 0
	ADDWF      R0+0, 1
	MOVF       _desbordes+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _desbordes+1, 0
	ADDWF      R0+1, 1
	MOVF       _desbordes+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _desbordes+2, 0
	ADDWF      R0+2, 1
	MOVF       _desbordes+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _desbordes+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _desbordes+0
	MOVF       R0+1, 0
	MOVWF      _desbordes+1
	MOVF       R0+2, 0
	MOVWF      _desbordes+2
	MOVF       R0+3, 0
	MOVWF      _desbordes+3
L_interrupt4:
;ADC_USART_INT_TMRX.c,17 :: 		if (PORTB.RB7 ==1) desbordes=desbordes-488;
	BTFSS      PORTB+0, 7
	GOTO       L_interrupt5
	MOVLW      232
	MOVWF      R0+0
	MOVLW      1
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R0+0, 0
	SUBWF      _desbordes+0, 1
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R0+1, 0
	SUBWF      _desbordes+1, 1
	MOVF       R0+2, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R0+2, 0
	SUBWF      _desbordes+2, 1
	MOVF       R0+3, 0
	BTFSS      STATUS+0, 0
	INCFSZ     R0+3, 0
	SUBWF      _desbordes+3, 1
L_interrupt5:
;ADC_USART_INT_TMRX.c,18 :: 		if (desbordes <= 488) desbordes=489;
	MOVF       _desbordes+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt33
	MOVF       _desbordes+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt33
	MOVF       _desbordes+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt33
	MOVF       _desbordes+0, 0
	SUBLW      232
L__interrupt33:
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt6
	MOVLW      233
	MOVWF      _desbordes+0
	MOVLW      1
	MOVWF      _desbordes+1
	CLRF       _desbordes+2
	CLRF       _desbordes+3
L_interrupt6:
;ADC_USART_INT_TMRX.c,19 :: 		INTCON.RBIF = 0;
	BCF        INTCON+0, 0
;ADC_USART_INT_TMRX.c,20 :: 		}
	GOTO       L_interrupt7
L_interrupt3:
;ADC_USART_INT_TMRX.c,21 :: 		else if (PIR1.TMR1IF) {
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt8
;ADC_USART_INT_TMRX.c,22 :: 		contador_TMR1++;
	MOVF       _contador_TMR1+0, 0
	MOVWF      R0+0
	MOVF       _contador_TMR1+1, 0
	MOVWF      R0+1
	MOVF       _contador_TMR1+2, 0
	MOVWF      R0+2
	MOVF       _contador_TMR1+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _contador_TMR1+0
	MOVF       R0+1, 0
	MOVWF      _contador_TMR1+1
	MOVF       R0+2, 0
	MOVWF      _contador_TMR1+2
	MOVF       R0+3, 0
	MOVWF      _contador_TMR1+3
;ADC_USART_INT_TMRX.c,23 :: 		if (contador_TMR1 == 76){   //Un segundo
	MOVLW      0
	MOVWF      R0+0
	XORWF      _contador_TMR1+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt34
	MOVF       R0+0, 0
	XORWF      _contador_TMR1+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt34
	MOVF       R0+0, 0
	XORWF      _contador_TMR1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt34
	MOVF       _contador_TMR1+0, 0
	XORLW      76
L__interrupt34:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt9
;ADC_USART_INT_TMRX.c,24 :: 		incrementar = 1;
	MOVLW      1
	MOVWF      _incrementar+0
;ADC_USART_INT_TMRX.c,25 :: 		contador_TMR1 = 0;
	CLRF       _contador_TMR1+0
	CLRF       _contador_TMR1+1
	CLRF       _contador_TMR1+2
	CLRF       _contador_TMR1+3
;ADC_USART_INT_TMRX.c,26 :: 		}
L_interrupt9:
;ADC_USART_INT_TMRX.c,27 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;ADC_USART_INT_TMRX.c,28 :: 		}
L_interrupt8:
L_interrupt7:
L_interrupt2:
;ADC_USART_INT_TMRX.c,29 :: 		}
L__interrupt31:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_incrementar_contador:

;ADC_USART_INT_TMRX.c,30 :: 		void incrementar_contador () {
;ADC_USART_INT_TMRX.c,31 :: 		i=i+1;
	INCF       _i+0, 1
;ADC_USART_INT_TMRX.c,32 :: 		if (i>99)i=0;
	MOVF       _i+0, 0
	SUBLW      99
	BTFSC      STATUS+0, 0
	GOTO       L_incrementar_contador10
	CLRF       _i+0
L_incrementar_contador10:
;ADC_USART_INT_TMRX.c,33 :: 		dato_2 = i/10;
	MOVLW      10
	MOVWF      R4+0
	MOVF       _i+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      _dato_2+0
;ADC_USART_INT_TMRX.c,34 :: 		dato_1 = (i - (dato_2*10));
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	SUBWF      _i+0, 0
	MOVWF      _dato_1+0
;ADC_USART_INT_TMRX.c,35 :: 		}
	RETURN
; end of _incrementar_contador

_ADC_UART:

;ADC_USART_INT_TMRX.c,37 :: 		void ADC_UART () {
;ADC_USART_INT_TMRX.c,38 :: 		temp_res = ADC_Read(4);   // Get 10-bit results of AD conversion
	MOVLW      4
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_res+0
	MOVF       R0+1, 0
	MOVWF      _temp_res+1
;ADC_USART_INT_TMRX.c,39 :: 		IntToStr(temp_res,txt);   //Convertir binario a Ascii
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;ADC_USART_INT_TMRX.c,40 :: 		UART1_Write_Text(txt);
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;ADC_USART_INT_TMRX.c,41 :: 		UART1_Write(10),UART1_Write(13); //Enter
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;ADC_USART_INT_TMRX.c,42 :: 		}
	RETURN
; end of _ADC_UART

_visualizar:

;ADC_USART_INT_TMRX.c,44 :: 		visualizar (unsigned short dato) {
;ADC_USART_INT_TMRX.c,45 :: 		switch (dato) {
	GOTO       L_visualizar11
;ADC_USART_INT_TMRX.c,46 :: 		case 0 :
L_visualizar13:
;ADC_USART_INT_TMRX.c,47 :: 		portc=0xC0;
	MOVLW      192
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,48 :: 		PORTB.RB5=1;
	BSF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,49 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,50 :: 		case 1 :
L_visualizar14:
;ADC_USART_INT_TMRX.c,51 :: 		portc=0xF9;
	MOVLW      249
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,52 :: 		PORTB.RB5=1;
	BSF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,53 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,54 :: 		case 2 :
L_visualizar15:
;ADC_USART_INT_TMRX.c,55 :: 		PORTc=0xA4;
	MOVLW      164
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,56 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,57 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,58 :: 		case 3 :
L_visualizar16:
;ADC_USART_INT_TMRX.c,59 :: 		PORTc=0xB0;
	MOVLW      176
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,60 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,61 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,62 :: 		case 4 :
L_visualizar17:
;ADC_USART_INT_TMRX.c,63 :: 		portc=0x99;
	MOVLW      153
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,64 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,65 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,66 :: 		case 5 :
L_visualizar18:
;ADC_USART_INT_TMRX.c,67 :: 		portc=0x92;
	MOVLW      146
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,68 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,69 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,70 :: 		case 6 :
L_visualizar19:
;ADC_USART_INT_TMRX.c,71 :: 		portc=0x82;
	MOVLW      130
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,72 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,73 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,74 :: 		case 7 :
L_visualizar20:
;ADC_USART_INT_TMRX.c,75 :: 		portc=0xF8;
	MOVLW      248
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,76 :: 		PORTB.RB5=1;
	BSF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,77 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,78 :: 		case 8 :
L_visualizar21:
;ADC_USART_INT_TMRX.c,79 :: 		portc=0x80;
	MOVLW      128
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,80 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,81 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,82 :: 		case 9 :
L_visualizar22:
;ADC_USART_INT_TMRX.c,83 :: 		portc=0x90;
	MOVLW      144
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,84 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;ADC_USART_INT_TMRX.c,85 :: 		break;
	GOTO       L_visualizar12
;ADC_USART_INT_TMRX.c,86 :: 		}
L_visualizar11:
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar13
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar14
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar15
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar16
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar17
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar18
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar19
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar20
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar21
	MOVF       FARG_visualizar_dato+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_visualizar22
L_visualizar12:
;ADC_USART_INT_TMRX.c,99 :: 		}
	RETURN
; end of _visualizar

_main:

;ADC_USART_INT_TMRX.c,100 :: 		void main() {
;ADC_USART_INT_TMRX.c,101 :: 		ANSEL  = 0B00010000;              // Configure AN5 pin as analog
	MOVLW      16
	MOVWF      ANSEL+0
;ADC_USART_INT_TMRX.c,102 :: 		ANSELH = 0X00;                 // Configure other AN pins as digital I/O
	CLRF       ANSELH+0
;ADC_USART_INT_TMRX.c,103 :: 		C1ON_bit = 0;               // Disable comparators
	BCF        C1ON_bit+0, 7
;ADC_USART_INT_TMRX.c,104 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, 7
;ADC_USART_INT_TMRX.c,106 :: 		TRISA  = 0B00100000;              // RA5(AN4) is input
	MOVLW      32
	MOVWF      TRISA+0
;ADC_USART_INT_TMRX.c,107 :: 		TRISC  = 0;                 // PORTC is output
	CLRF       TRISC+0
;ADC_USART_INT_TMRX.c,108 :: 		TRISB  = 0b11000000;                 // RB7 and RB6 are outputs
	MOVLW      192
	MOVWF      TRISB+0
;ADC_USART_INT_TMRX.c,110 :: 		PORTB = PORTA = 0;
	CLRF       PORTA+0
	MOVF       PORTA+0, 0
	MOVWF      PORTB+0
;ADC_USART_INT_TMRX.c,112 :: 		OPTION_REG = 0B01000000;      //Prescaler 1:2, INT por flanco de subida, Prescaler pa' TMR0
	MOVLW      64
	MOVWF      OPTION_REG+0
;ADC_USART_INT_TMRX.c,113 :: 		INTCON = 0B11111000;          //Habilitadas INT ext, RBChange, TMR0 int además de las periféricas y las globales
	MOVLW      248
	MOVWF      INTCON+0
;ADC_USART_INT_TMRX.c,114 :: 		IOCB = 0B11000000;            //RB6 y RB7 generan interrupción
	MOVLW      192
	MOVWF      IOCB+0
;ADC_USART_INT_TMRX.c,116 :: 		PIE1.TMR1IE = 1;      //Se habilita la interupción por Timer1
	BSF        PIE1+0, 0
;ADC_USART_INT_TMRX.c,117 :: 		T1CON = 0b10000001;   //Se configura el preescaler del Timer a 1:1, se utiliza el reloj interno (Timer)
	MOVLW      129
	MOVWF      T1CON+0
;ADC_USART_INT_TMRX.c,120 :: 		UART1_INIT(115200);
	MOVLW      10
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;ADC_USART_INT_TMRX.c,121 :: 		Delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	NOP
;ADC_USART_INT_TMRX.c,122 :: 		UART1_Write_text("Junior");
	MOVLW      ?lstr1_ADC_USART_INT_TMRX+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;ADC_USART_INT_TMRX.c,125 :: 		contador_TMR0 = 0;
	CLRF       _contador_TMR0+0
	CLRF       _contador_TMR0+1
	CLRF       _contador_TMR0+2
	CLRF       _contador_TMR0+3
;ADC_USART_INT_TMRX.c,126 :: 		contador_TMR1 = 0;
	CLRF       _contador_TMR1+0
	CLRF       _contador_TMR1+1
	CLRF       _contador_TMR1+2
	CLRF       _contador_TMR1+3
;ADC_USART_INT_TMRX.c,127 :: 		envio_ADC = 0;
	CLRF       _envio_ADC+0
;ADC_USART_INT_TMRX.c,128 :: 		desbordes = 9766; //9766 desbordes del TMR0 a 1:2 da aprox. 1seg
	MOVLW      38
	MOVWF      _desbordes+0
	MOVLW      38
	MOVWF      _desbordes+1
	CLRF       _desbordes+2
	CLRF       _desbordes+3
;ADC_USART_INT_TMRX.c,129 :: 		dato_1 = 0;
	CLRF       _dato_1+0
;ADC_USART_INT_TMRX.c,130 :: 		dato_2 = 0;
	CLRF       _dato_2+0
;ADC_USART_INT_TMRX.c,131 :: 		i = 0;
	CLRF       _i+0
;ADC_USART_INT_TMRX.c,132 :: 		PORTC=0xC0;  // INICIALIZACIÓN DEL PUERTO A EN CERO DE 7-SEGMENTOS
	MOVLW      192
	MOVWF      PORTC+0
;ADC_USART_INT_TMRX.c,133 :: 		TMR0 = 0;
	CLRF       TMR0+0
;ADC_USART_INT_TMRX.c,135 :: 		do {
L_main24:
;ADC_USART_INT_TMRX.c,136 :: 		if (envio_ADC == 1) {
	MOVF       _envio_ADC+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main27
;ADC_USART_INT_TMRX.c,137 :: 		ADC_UART();
	CALL       _ADC_UART+0
;ADC_USART_INT_TMRX.c,138 :: 		envio_ADC = 0;
	CLRF       _envio_ADC+0
;ADC_USART_INT_TMRX.c,139 :: 		}
L_main27:
;ADC_USART_INT_TMRX.c,141 :: 		if (incrementar == 1) {
	MOVF       _incrementar+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main28
;ADC_USART_INT_TMRX.c,142 :: 		incrementar_contador();
	CALL       _incrementar_contador+0
;ADC_USART_INT_TMRX.c,143 :: 		incrementar = 0;
	CLRF       _incrementar+0
;ADC_USART_INT_TMRX.c,144 :: 		}
L_main28:
;ADC_USART_INT_TMRX.c,146 :: 		PORTB.RB2 =1,   PORTB.RB1 =0;
	BSF        PORTB+0, 2
	BCF        PORTB+0, 1
;ADC_USART_INT_TMRX.c,147 :: 		visualizar(dato_1);
	MOVF       _dato_1+0, 0
	MOVWF      FARG_visualizar_dato+0
	CALL       _visualizar+0
;ADC_USART_INT_TMRX.c,148 :: 		delay_ms(30);
	MOVLW      195
	MOVWF      R12+0
	MOVLW      205
	MOVWF      R13+0
L_main29:
	DECFSZ     R13+0, 1
	GOTO       L_main29
	DECFSZ     R12+0, 1
	GOTO       L_main29
;ADC_USART_INT_TMRX.c,150 :: 		PORTB.RB2 =0,   PORTB.RB1 =1;
	BCF        PORTB+0, 2
	BSF        PORTB+0, 1
;ADC_USART_INT_TMRX.c,151 :: 		visualizar(dato_2);
	MOVF       _dato_2+0, 0
	MOVWF      FARG_visualizar_dato+0
	CALL       _visualizar+0
;ADC_USART_INT_TMRX.c,152 :: 		delay_ms(30);
	MOVLW      195
	MOVWF      R12+0
	MOVLW      205
	MOVWF      R13+0
L_main30:
	DECFSZ     R13+0, 1
	GOTO       L_main30
	DECFSZ     R12+0, 1
	GOTO       L_main30
;ADC_USART_INT_TMRX.c,154 :: 		} while(729);
	GOTO       L_main24
;ADC_USART_INT_TMRX.c,156 :: 		}
	GOTO       $+0
; end of _main
