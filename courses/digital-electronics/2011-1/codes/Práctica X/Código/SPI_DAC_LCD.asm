
_DAC_Output:

;SPI_DAC_LCD.c,31 :: 		void DAC_Output(unsigned int valueDAC) {
;SPI_DAC_LCD.c,34 :: 		Chip_Select = 0;                       // Select DAC chip
	BCF        RC0_bit+0, 0
;SPI_DAC_LCD.c,37 :: 		temp = (valueDAC >> 8) & 0x0F;         // Store valueDAC[11..8] to temp[3..0]
	MOVF       FARG_DAC_Output_valueDAC+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVLW      15
	ANDWF      R0+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
;SPI_DAC_LCD.c,38 :: 		temp |= 0x30;                          // Define DAC setting, see MCP4921 datasheet
	MOVLW      48
	IORWF      FARG_SPI1_Write_data_+0, 1
;SPI_DAC_LCD.c,39 :: 		SPI1_Write(temp);                      // Send high byte via SPI
	CALL       _SPI1_Write+0
;SPI_DAC_LCD.c,43 :: 		SPI1_Write(temp);                      // Send low byte via SPI
	MOVF       FARG_DAC_Output_valueDAC+0, 0
	MOVWF      FARG_SPI1_Write_data_+0
	CALL       _SPI1_Write+0
;SPI_DAC_LCD.c,45 :: 		Chip_Select = 1;                       // Deselect DAC chip
	BSF        RC0_bit+0, 0
;SPI_DAC_LCD.c,46 :: 		}
	RETURN
; end of _DAC_Output

_visualizar_LCD:

;SPI_DAC_LCD.c,47 :: 		void visualizar_LCD() {
;SPI_DAC_LCD.c,49 :: 		IntToStr(value,txt);
	MOVF       _value+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _value+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;SPI_DAC_LCD.c,50 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SPI_DAC_LCD.c,51 :: 		Lcd_Out(1,1,"Dato: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_SPI_DAC_LCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SPI_DAC_LCD.c,52 :: 		Lcd_Out(1,7,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SPI_DAC_LCD.c,54 :: 		IntToStr(datos_enviados,txt);
	MOVF       _datos_enviados+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _datos_enviados+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;SPI_DAC_LCD.c,55 :: 		Lcd_Out(2,1,"Dato # :");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_SPI_DAC_LCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SPI_DAC_LCD.c,56 :: 		Lcd_Out(2,9,txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SPI_DAC_LCD.c,57 :: 		}
	RETURN
; end of _visualizar_LCD

_main:

;SPI_DAC_LCD.c,58 :: 		void main(){
;SPI_DAC_LCD.c,59 :: 		ANSEL  = 0;                        // Configure AN pins as digital I/O
	CLRF       ANSEL+0
;SPI_DAC_LCD.c,60 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;SPI_DAC_LCD.c,61 :: 		C1ON_bit = 0;                      // Disable comparators
	BCF        C1ON_bit+0, 7
;SPI_DAC_LCD.c,62 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, 7
;SPI_DAC_LCD.c,64 :: 		TRISA0_bit = 1;                        // Set RA0 pin as input
	BSF        TRISA0_bit+0, 0
;SPI_DAC_LCD.c,65 :: 		TRISA1_bit = 1;                        // Set RA1 pin as input
	BSF        TRISA1_bit+0, 1
;SPI_DAC_LCD.c,66 :: 		Chip_Select = 1;                       // Deselect DAC
	BSF        RC0_bit+0, 0
;SPI_DAC_LCD.c,67 :: 		Chip_Select_Direction = 0;             // Set CS# pin as Output
	BCF        TRISC0_bit+0, 0
;SPI_DAC_LCD.c,68 :: 		SPI1_Init();                           // Initialize SPI module
	CALL       _SPI1_Init+0
;SPI_DAC_LCD.c,70 :: 		value = 2048;                          // When program starts, DAC gives
	MOVLW      0
	MOVWF      _value+0
	MOVLW      8
	MOVWF      _value+1
;SPI_DAC_LCD.c,73 :: 		datos_enviados = 0;                 //Datos enviados al DAC
	CLRF       _datos_enviados+0
	CLRF       _datos_enviados+1
;SPI_DAC_LCD.c,75 :: 		DAC_Output(value);
	MOVLW      0
	MOVWF      FARG_DAC_Output_valueDAC+0
	MOVLW      8
	MOVWF      FARG_DAC_Output_valueDAC+1
	CALL       _DAC_Output+0
;SPI_DAC_LCD.c,77 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;SPI_DAC_LCD.c,79 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SPI_DAC_LCD.c,80 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SPI_DAC_LCD.c,81 :: 		Lcd_Out(1,1,txt1);                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt1+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SPI_DAC_LCD.c,83 :: 		Lcd_Out(2,6,txt2);                 // Write text in second row
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt2+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;SPI_DAC_LCD.c,84 :: 		Delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;SPI_DAC_LCD.c,85 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;SPI_DAC_LCD.c,87 :: 		visualizar_LCD();
	CALL       _visualizar_LCD+0
;SPI_DAC_LCD.c,90 :: 		while(1) {                         // Endless loop
L_main1:
;SPI_DAC_LCD.c,91 :: 		if (RA0_bit==0) a=1;
	BTFSC      RA0_bit+0, 0
	GOTO       L_main3
	MOVLW      1
	MOVWF      _a+0
	MOVLW      0
	MOVWF      _a+1
L_main3:
;SPI_DAC_LCD.c,92 :: 		if ((RA0_bit) && (value < 4095) && a==1) {   // If RA0 button is pressed
	BTFSS      RA0_bit+0, 0
	GOTO       L_main6
	MOVLW      15
	SUBWF      _value+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main14
	MOVLW      255
	SUBWF      _value+0, 0
L__main14:
	BTFSC      STATUS+0, 0
	GOTO       L_main6
	MOVLW      0
	XORWF      _a+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main15
	MOVLW      1
	XORWF      _a+0, 0
L__main15:
	BTFSS      STATUS+0, 2
	GOTO       L_main6
L__main13:
;SPI_DAC_LCD.c,93 :: 		value++;                           //   increment value
	INCF       _value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _value+1, 1
;SPI_DAC_LCD.c,94 :: 		datos_enviados++;
	INCF       _datos_enviados+0, 1
	BTFSC      STATUS+0, 2
	INCF       _datos_enviados+1, 1
;SPI_DAC_LCD.c,95 :: 		visualizar_LCD();
	CALL       _visualizar_LCD+0
;SPI_DAC_LCD.c,96 :: 		a=0;
	CLRF       _a+0
	CLRF       _a+1
;SPI_DAC_LCD.c,97 :: 		}
L_main6:
;SPI_DAC_LCD.c,99 :: 		if (RA1_bit==0) b=1;
	BTFSC      RA1_bit+0, 1
	GOTO       L_main7
	MOVLW      1
	MOVWF      _b+0
	MOVLW      0
	MOVWF      _b+1
L_main7:
;SPI_DAC_LCD.c,100 :: 		if ((RA1_bit) && (value > 0) && b==1) {    // If RA1 button is pressed
	BTFSS      RA1_bit+0, 1
	GOTO       L_main10
	MOVF       _value+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main16
	MOVF       _value+0, 0
	SUBLW      0
L__main16:
	BTFSC      STATUS+0, 0
	GOTO       L_main10
	MOVLW      0
	XORWF      _b+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main17
	MOVLW      1
	XORWF      _b+0, 0
L__main17:
	BTFSS      STATUS+0, 2
	GOTO       L_main10
L__main12:
;SPI_DAC_LCD.c,101 :: 		value--;                         //   decrement value
	MOVLW      1
	SUBWF      _value+0, 1
	BTFSS      STATUS+0, 0
	DECF       _value+1, 1
;SPI_DAC_LCD.c,102 :: 		datos_enviados++;
	INCF       _datos_enviados+0, 1
	BTFSC      STATUS+0, 2
	INCF       _datos_enviados+1, 1
;SPI_DAC_LCD.c,103 :: 		visualizar_LCD();
	CALL       _visualizar_LCD+0
;SPI_DAC_LCD.c,104 :: 		b=0;
	CLRF       _b+0
	CLRF       _b+1
;SPI_DAC_LCD.c,105 :: 		}
L_main10:
;SPI_DAC_LCD.c,107 :: 		DAC_Output(value);                   // Send value to DAC chip
	MOVF       _value+0, 0
	MOVWF      FARG_DAC_Output_valueDAC+0
	MOVF       _value+1, 0
	MOVWF      FARG_DAC_Output_valueDAC+1
	CALL       _DAC_Output+0
;SPI_DAC_LCD.c,109 :: 		Delay_ms(1);                         // Slow down key repeat pace
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_main11:
	DECFSZ     R13+0, 1
	GOTO       L_main11
	DECFSZ     R12+0, 1
	GOTO       L_main11
;SPI_DAC_LCD.c,112 :: 		}
	GOTO       L_main1
;SPI_DAC_LCD.c,113 :: 		}
	GOTO       $+0
; end of _main
