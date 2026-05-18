
_efectuar:

;LCD_Calc_Teclado.c,29 :: 		void efectuar () {
;LCD_Calc_Teclado.c,30 :: 		switch (kp) {
	GOTO       L_efectuar0
;LCD_Calc_Teclado.c,31 :: 		case  '+': resultado = (variable1+variable2); break;
L_efectuar2:
	MOVF       _variable1+0, 0
	MOVWF      R0+0
	MOVF       _variable1+1, 0
	MOVWF      R0+1
	MOVF       _variable1+2, 0
	MOVWF      R0+2
	MOVF       _variable1+3, 0
	MOVWF      R0+3
	MOVF       _variable2+0, 0
	MOVWF      R4+0
	MOVF       _variable2+1, 0
	MOVWF      R4+1
	MOVF       _variable2+2, 0
	MOVWF      R4+2
	MOVF       _variable2+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _resultado+0
	MOVF       R0+1, 0
	MOVWF      _resultado+1
	MOVF       R0+2, 0
	MOVWF      _resultado+2
	MOVF       R0+3, 0
	MOVWF      _resultado+3
	GOTO       L_efectuar1
;LCD_Calc_Teclado.c,32 :: 		case  '-': resultado = (variable1-variable2); break;
L_efectuar3:
	MOVF       _variable2+0, 0
	MOVWF      R4+0
	MOVF       _variable2+1, 0
	MOVWF      R4+1
	MOVF       _variable2+2, 0
	MOVWF      R4+2
	MOVF       _variable2+3, 0
	MOVWF      R4+3
	MOVF       _variable1+0, 0
	MOVWF      R0+0
	MOVF       _variable1+1, 0
	MOVWF      R0+1
	MOVF       _variable1+2, 0
	MOVWF      R0+2
	MOVF       _variable1+3, 0
	MOVWF      R0+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _resultado+0
	MOVF       R0+1, 0
	MOVWF      _resultado+1
	MOVF       R0+2, 0
	MOVWF      _resultado+2
	MOVF       R0+3, 0
	MOVWF      _resultado+3
	GOTO       L_efectuar1
;LCD_Calc_Teclado.c,33 :: 		case  'x': resultado = (variable1*variable2); break;
L_efectuar4:
	MOVF       _variable1+0, 0
	MOVWF      R0+0
	MOVF       _variable1+1, 0
	MOVWF      R0+1
	MOVF       _variable1+2, 0
	MOVWF      R0+2
	MOVF       _variable1+3, 0
	MOVWF      R0+3
	MOVF       _variable2+0, 0
	MOVWF      R4+0
	MOVF       _variable2+1, 0
	MOVWF      R4+1
	MOVF       _variable2+2, 0
	MOVWF      R4+2
	MOVF       _variable2+3, 0
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _resultado+0
	MOVF       R0+1, 0
	MOVWF      _resultado+1
	MOVF       R0+2, 0
	MOVWF      _resultado+2
	MOVF       R0+3, 0
	MOVWF      _resultado+3
	GOTO       L_efectuar1
;LCD_Calc_Teclado.c,34 :: 		case  '/': resultado = (variable1/variable2); break;
L_efectuar5:
	MOVF       _variable2+0, 0
	MOVWF      R4+0
	MOVF       _variable2+1, 0
	MOVWF      R4+1
	MOVF       _variable2+2, 0
	MOVWF      R4+2
	MOVF       _variable2+3, 0
	MOVWF      R4+3
	MOVF       _variable1+0, 0
	MOVWF      R0+0
	MOVF       _variable1+1, 0
	MOVWF      R0+1
	MOVF       _variable1+2, 0
	MOVWF      R0+2
	MOVF       _variable1+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _resultado+0
	MOVF       R0+1, 0
	MOVWF      _resultado+1
	MOVF       R0+2, 0
	MOVWF      _resultado+2
	MOVF       R0+3, 0
	MOVWF      _resultado+3
	GOTO       L_efectuar1
;LCD_Calc_Teclado.c,35 :: 		}
L_efectuar0:
	MOVF       _kp+0, 0
	XORLW      43
	BTFSC      STATUS+0, 2
	GOTO       L_efectuar2
	MOVF       _kp+0, 0
	XORLW      45
	BTFSC      STATUS+0, 2
	GOTO       L_efectuar3
	MOVF       _kp+0, 0
	XORLW      120
	BTFSC      STATUS+0, 2
	GOTO       L_efectuar4
	MOVF       _kp+0, 0
	XORLW      47
	BTFSC      STATUS+0, 2
	GOTO       L_efectuar5
L_efectuar1:
;LCD_Calc_Teclado.c,36 :: 		}
	RETURN
; end of _efectuar

_main:

;LCD_Calc_Teclado.c,38 :: 		void main() {
;LCD_Calc_Teclado.c,39 :: 		Keypad_Init();                           // Initialize Keypad
	CALL       _Keypad_Init+0
;LCD_Calc_Teclado.c,40 :: 		ANSEL  = 0;                              // Configure AN pins as digital I/O
	CLRF       ANSEL+0
;LCD_Calc_Teclado.c,41 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;LCD_Calc_Teclado.c,42 :: 		Lcd_Init();                              // Initialize LCD
	CALL       _Lcd_Init+0
;LCD_Calc_Teclado.c,43 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCD_Calc_Teclado.c,44 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCD_Calc_Teclado.c,45 :: 		Lcd_Out(1, 1, "   Calculadora");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,46 :: 		Lcd_Out(2, 1, "     C.A.T.A");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,47 :: 		delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
;LCD_Calc_Teclado.c,49 :: 		while (1) {
L_main7:
;LCD_Calc_Teclado.c,50 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCD_Calc_Teclado.c,51 :: 		Lcd_Out(1, 1, "    Primer #?");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,53 :: 		Numero1:
___main_Numero1:
;LCD_Calc_Teclado.c,54 :: 		kp=0;
	CLRF       _kp+0
;LCD_Calc_Teclado.c,56 :: 		do kp = Keypad_Key_Click();             // Store key code in kp variable
L_main9:
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;LCD_Calc_Teclado.c,57 :: 		while (!kp);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
;LCD_Calc_Teclado.c,59 :: 		switch (kp) {
	GOTO       L_main12
;LCD_Calc_Teclado.c,60 :: 		case  1: kp = 55; oldstate=7; break; // 7        // Uncomment this block for keypad4x4
L_main14:
	MOVLW      55
	MOVWF      _kp+0
	MOVLW      7
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,61 :: 		case  2: kp = 56; oldstate=8; break; // 8
L_main15:
	MOVLW      56
	MOVWF      _kp+0
	MOVLW      8
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,62 :: 		case  3: kp = 57; oldstate=9; break; // 9
L_main16:
	MOVLW      57
	MOVWF      _kp+0
	MOVLW      9
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,63 :: 		case  5: kp = 52; oldstate=4; break; // 4
L_main17:
	MOVLW      52
	MOVWF      _kp+0
	MOVLW      4
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,64 :: 		case  6: kp = 53; oldstate=5; break; // 5
L_main18:
	MOVLW      53
	MOVWF      _kp+0
	MOVLW      5
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,65 :: 		case  7: kp = 54; oldstate=6; break; // 6
L_main19:
	MOVLW      54
	MOVWF      _kp+0
	MOVLW      6
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,66 :: 		case  9: kp = 49; oldstate=1; break; // 1
L_main20:
	MOVLW      49
	MOVWF      _kp+0
	MOVLW      1
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,67 :: 		case 10: kp = 50; oldstate=2; break; // 2
L_main21:
	MOVLW      50
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,68 :: 		case 11: kp = 51; oldstate=3; break; // 3
L_main22:
	MOVLW      51
	MOVWF      _kp+0
	MOVLW      3
	MOVWF      _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,69 :: 		case 13: kp = 'C'; break; // C
L_main23:
	MOVLW      67
	MOVWF      _kp+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,70 :: 		case 14: kp = 48; oldstate=0; break; // 0
L_main24:
	MOVLW      48
	MOVWF      _kp+0
	CLRF       _oldstate+0
	GOTO       L_main13
;LCD_Calc_Teclado.c,71 :: 		default : goto Numero1;
L_main25:
	GOTO       ___main_Numero1
;LCD_Calc_Teclado.c,72 :: 		}
L_main12:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main14
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main15
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main16
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main17
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main19
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main20
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main21
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main22
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main23
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main24
	GOTO       L_main25
L_main13:
;LCD_Calc_Teclado.c,74 :: 		Lcd_Chr(2, i, kp);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _kp+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;LCD_Calc_Teclado.c,75 :: 		numero[j]=oldstate;
	MOVF       _j+0, 0
	ADDLW      _numero+0
	MOVWF      FSR
	MOVF       _oldstate+0, 0
	MOVWF      INDF+0
;LCD_Calc_Teclado.c,76 :: 		i++;
	INCF       _i+0, 1
;LCD_Calc_Teclado.c,77 :: 		j++;
	INCF       _j+0, 1
;LCD_Calc_Teclado.c,78 :: 		if (kp != 'C') goto Numero1;
	MOVF       _kp+0, 0
	XORLW      67
	BTFSC      STATUS+0, 2
	GOTO       L_main26
	GOTO       ___main_Numero1
L_main26:
;LCD_Calc_Teclado.c,79 :: 		if (j==3) variable1 = numero[1];
	MOVF       _j+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      R0+0, 7
	MOVLW      255
	MOVWF      R0+1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable1+0
	MOVF       R0+1, 0
	MOVWF      _variable1+1
	MOVF       R0+2, 0
	MOVWF      _variable1+2
	MOVF       R0+3, 0
	MOVWF      _variable1+3
L_main27:
;LCD_Calc_Teclado.c,80 :: 		if (j==4) variable1 = numero[1]*10 + numero[2];
	MOVF       _j+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       _numero+2, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      0
	BTFSC      _numero+2, 7
	MOVLW      255
	ADDWF      R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable1+0
	MOVF       R0+1, 0
	MOVWF      _variable1+1
	MOVF       R0+2, 0
	MOVWF      _variable1+2
	MOVF       R0+3, 0
	MOVWF      _variable1+3
L_main28:
;LCD_Calc_Teclado.c,81 :: 		if (j==5) variable1 = numero[1]*100 + numero[2]*10 + numero[3];
	MOVF       _j+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_main29
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       _numero+2, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       _numero+3, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      0
	BTFSC      _numero+3, 7
	MOVLW      255
	ADDWF      R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable1+0
	MOVF       R0+1, 0
	MOVWF      _variable1+1
	MOVF       R0+2, 0
	MOVWF      _variable1+2
	MOVF       R0+3, 0
	MOVWF      _variable1+3
L_main29:
;LCD_Calc_Teclado.c,82 :: 		if (j==6) variable1 = numero[1]*1000 + numero[2]*100 + numero[3]*10 + numero[4];
	MOVF       _j+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_main30
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      R0+0, 7
	MOVLW      255
	MOVWF      R0+1
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       _numero+2, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       R0+0, 0
	ADDWF      FLOC__main+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      FLOC__main+1, 1
	MOVF       _numero+3, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       _numero+4, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      0
	BTFSC      _numero+4, 7
	MOVLW      255
	ADDWF      R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable1+0
	MOVF       R0+1, 0
	MOVWF      _variable1+1
	MOVF       R0+2, 0
	MOVWF      _variable1+2
	MOVF       R0+3, 0
	MOVWF      _variable1+3
L_main30:
;LCD_Calc_Teclado.c,83 :: 		numero[2] = 0;numero[1] = 0; numero[3] = 0;
	CLRF       _numero+2
	CLRF       _numero+1
	CLRF       _numero+3
;LCD_Calc_Teclado.c,84 :: 		i=8;
	MOVLW      8
	MOVWF      _i+0
;LCD_Calc_Teclado.c,85 :: 		j=1;
	MOVLW      1
	MOVWF      _j+0
;LCD_Calc_Teclado.c,87 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCD_Calc_Teclado.c,88 :: 		Lcd_Out(1, 1, "   Segundo #?");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,90 :: 		Numero2:
___main_Numero2:
;LCD_Calc_Teclado.c,91 :: 		kp=0;
	CLRF       _kp+0
;LCD_Calc_Teclado.c,93 :: 		do kp = Keypad_Key_Click();             // Store key code in kp variable
L_main31:
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;LCD_Calc_Teclado.c,94 :: 		while (!kp);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main31
;LCD_Calc_Teclado.c,96 :: 		switch (kp) {
	GOTO       L_main34
;LCD_Calc_Teclado.c,97 :: 		case  1: kp = 55; oldstate=7; break; // 7        // Uncomment this block for keypad4x4
L_main36:
	MOVLW      55
	MOVWF      _kp+0
	MOVLW      7
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,98 :: 		case  2: kp = 56; oldstate=8; break; // 8
L_main37:
	MOVLW      56
	MOVWF      _kp+0
	MOVLW      8
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,99 :: 		case  3: kp = 57; oldstate=9; break; // 9
L_main38:
	MOVLW      57
	MOVWF      _kp+0
	MOVLW      9
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,100 :: 		case  5: kp = 52; oldstate=4; break; // 4
L_main39:
	MOVLW      52
	MOVWF      _kp+0
	MOVLW      4
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,101 :: 		case  6: kp = 53; oldstate=5; break; // 5
L_main40:
	MOVLW      53
	MOVWF      _kp+0
	MOVLW      5
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,102 :: 		case  7: kp = 54; oldstate=6; break; // 6
L_main41:
	MOVLW      54
	MOVWF      _kp+0
	MOVLW      6
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,103 :: 		case  9: kp = 49; oldstate=1; break; // 1
L_main42:
	MOVLW      49
	MOVWF      _kp+0
	MOVLW      1
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,104 :: 		case 10: kp = 50; oldstate=2; break; // 2
L_main43:
	MOVLW      50
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,105 :: 		case 11: kp = 51; oldstate=3; break; // 3
L_main44:
	MOVLW      51
	MOVWF      _kp+0
	MOVLW      3
	MOVWF      _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,106 :: 		case 13: kp = 'C'; break; // C
L_main45:
	MOVLW      67
	MOVWF      _kp+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,107 :: 		case 14: kp = 48; oldstate=0; break; // 0
L_main46:
	MOVLW      48
	MOVWF      _kp+0
	CLRF       _oldstate+0
	GOTO       L_main35
;LCD_Calc_Teclado.c,108 :: 		default : goto Numero2;
L_main47:
	GOTO       ___main_Numero2
;LCD_Calc_Teclado.c,109 :: 		}
L_main34:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main36
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main37
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main38
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main39
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main40
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main41
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main42
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main43
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main44
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main45
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main46
	GOTO       L_main47
L_main35:
;LCD_Calc_Teclado.c,111 :: 		Lcd_Chr(2, i, kp);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _kp+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;LCD_Calc_Teclado.c,112 :: 		numero[j]=oldstate;
	MOVF       _j+0, 0
	ADDLW      _numero+0
	MOVWF      FSR
	MOVF       _oldstate+0, 0
	MOVWF      INDF+0
;LCD_Calc_Teclado.c,113 :: 		i++;
	INCF       _i+0, 1
;LCD_Calc_Teclado.c,114 :: 		j++;
	INCF       _j+0, 1
;LCD_Calc_Teclado.c,115 :: 		if (kp != 'C') goto Numero2;
	MOVF       _kp+0, 0
	XORLW      67
	BTFSC      STATUS+0, 2
	GOTO       L_main48
	GOTO       ___main_Numero2
L_main48:
;LCD_Calc_Teclado.c,116 :: 		if (j==3) variable2 = numero[1];
	MOVF       _j+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main49
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      R0+0, 7
	MOVLW      255
	MOVWF      R0+1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable2+0
	MOVF       R0+1, 0
	MOVWF      _variable2+1
	MOVF       R0+2, 0
	MOVWF      _variable2+2
	MOVF       R0+3, 0
	MOVWF      _variable2+3
L_main49:
;LCD_Calc_Teclado.c,117 :: 		if (j==4) variable2 = numero[1]*10 + numero[2];
	MOVF       _j+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_main50
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       _numero+2, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      0
	BTFSC      _numero+2, 7
	MOVLW      255
	ADDWF      R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable2+0
	MOVF       R0+1, 0
	MOVWF      _variable2+1
	MOVF       R0+2, 0
	MOVWF      _variable2+2
	MOVF       R0+3, 0
	MOVWF      _variable2+3
L_main50:
;LCD_Calc_Teclado.c,118 :: 		if (j==5) variable2 = numero[1]*100 + numero[2]*10 + numero[3];
	MOVF       _j+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_main51
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       _numero+2, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       _numero+3, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      0
	BTFSC      _numero+3, 7
	MOVLW      255
	ADDWF      R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable2+0
	MOVF       R0+1, 0
	MOVWF      _variable2+1
	MOVF       R0+2, 0
	MOVWF      _variable2+2
	MOVF       R0+3, 0
	MOVWF      _variable2+3
L_main51:
;LCD_Calc_Teclado.c,119 :: 		if (j==6) variable2 = numero[1]*1000 + numero[2]*100 + numero[3]*10 + numero[4];
	MOVF       _j+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_main52
	MOVF       _numero+1, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSC      R0+0, 7
	MOVLW      255
	MOVWF      R0+1
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       _numero+2, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       R0+0, 0
	ADDWF      FLOC__main+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      FLOC__main+1, 1
	MOVF       _numero+3, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_S+0
	MOVF       FLOC__main+0, 0
	ADDWF      R0+0, 1
	MOVF       FLOC__main+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVF       _numero+4, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      0
	BTFSC      _numero+4, 7
	MOVLW      255
	ADDWF      R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      _variable2+0
	MOVF       R0+1, 0
	MOVWF      _variable2+1
	MOVF       R0+2, 0
	MOVWF      _variable2+2
	MOVF       R0+3, 0
	MOVWF      _variable2+3
L_main52:
;LCD_Calc_Teclado.c,120 :: 		numero[1] = 0;numero[3] = 0; numero[2] = 0;
	CLRF       _numero+1
	CLRF       _numero+3
	CLRF       _numero+2
;LCD_Calc_Teclado.c,121 :: 		i=8;
	MOVLW      8
	MOVWF      _i+0
;LCD_Calc_Teclado.c,122 :: 		j=1;
	MOVLW      1
	MOVWF      _j+0
;LCD_Calc_Teclado.c,124 :: 		operacion_:
___main_operacion_:
;LCD_Calc_Teclado.c,125 :: 		kp=0;
	CLRF       _kp+0
;LCD_Calc_Teclado.c,126 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCD_Calc_Teclado.c,127 :: 		Lcd_Out(1, 1, "   Operacion?");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,130 :: 		do kp = Keypad_Key_Click();             // Store key code in kp variable
L_main53:
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;LCD_Calc_Teclado.c,131 :: 		while (!kp);
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main53
;LCD_Calc_Teclado.c,133 :: 		switch (kp){
	GOTO       L_main56
;LCD_Calc_Teclado.c,134 :: 		case  4: kp = '/'; Lcd_Chr(2, i, kp); efectuar(); break; // /
L_main58:
	MOVLW      47
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      47
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	CALL       _efectuar+0
	GOTO       L_main57
;LCD_Calc_Teclado.c,135 :: 		case  8: kp = 'x'; Lcd_Chr(2, i, kp); efectuar(); break; // x
L_main59:
	MOVLW      120
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      120
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	CALL       _efectuar+0
	GOTO       L_main57
;LCD_Calc_Teclado.c,136 :: 		case 12: kp = '-'; Lcd_Chr(2, i, kp); efectuar(); break; // -
L_main60:
	MOVLW      45
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      45
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	CALL       _efectuar+0
	GOTO       L_main57
;LCD_Calc_Teclado.c,137 :: 		case 16: kp = '+'; Lcd_Chr(2, i, kp); efectuar(); break; // +
L_main61:
	MOVLW      43
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _i+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      43
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	CALL       _efectuar+0
	GOTO       L_main57
;LCD_Calc_Teclado.c,138 :: 		default :
L_main62:
;LCD_Calc_Teclado.c,139 :: 		Lcd_Out(2, 1, "Escoja Operacion");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,140 :: 		delay_ms(1000);
	MOVLW      26
	MOVWF      R11+0
	MOVLW      94
	MOVWF      R12+0
	MOVLW      110
	MOVWF      R13+0
L_main63:
	DECFSZ     R13+0, 1
	GOTO       L_main63
	DECFSZ     R12+0, 1
	GOTO       L_main63
	DECFSZ     R11+0, 1
	GOTO       L_main63
	NOP
;LCD_Calc_Teclado.c,141 :: 		goto operacion_;
	GOTO       ___main_operacion_
;LCD_Calc_Teclado.c,142 :: 		}
L_main56:
	MOVF       _kp+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main58
	MOVF       _kp+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_main59
	MOVF       _kp+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_main60
	MOVF       _kp+0, 0
	XORLW      16
	BTFSC      STATUS+0, 2
	GOTO       L_main61
	GOTO       L_main62
L_main57:
;LCD_Calc_Teclado.c,143 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_main64:
	DECFSZ     R13+0, 1
	GOTO       L_main64
	DECFSZ     R12+0, 1
	GOTO       L_main64
	DECFSZ     R11+0, 1
	GOTO       L_main64
	NOP
	NOP
;LCD_Calc_Teclado.c,146 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;LCD_Calc_Teclado.c,147 :: 		Lcd_Out(1, 1, "   Resultado:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_LCD_Calc_Teclado+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,148 :: 		FloatToStr(resultado, txt);
	MOVF       _resultado+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       _resultado+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       _resultado+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       _resultado+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _txt+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;LCD_Calc_Teclado.c,149 :: 		Lcd_Out(2, 4, txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;LCD_Calc_Teclado.c,151 :: 		delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main65:
	DECFSZ     R13+0, 1
	GOTO       L_main65
	DECFSZ     R12+0, 1
	GOTO       L_main65
	DECFSZ     R11+0, 1
	GOTO       L_main65
	NOP
	NOP
;LCD_Calc_Teclado.c,154 :: 		}
	GOTO       L_main7
;LCD_Calc_Teclado.c,155 :: 		}
	GOTO       $+0
; end of _main
