
_capturar:

;KKeyPad_LCD.c,25 :: 		float capturar () {
;KKeyPad_LCD.c,27 :: 		variable = (temp1*10) + temp2;
	MOVF       _temp1+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       _temp2+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	CALL       _Int2Double+0
	MOVF       R0+0, 0
	MOVWF      capturar_variable_L0+0
	MOVF       R0+1, 0
	MOVWF      capturar_variable_L0+1
	MOVF       R0+2, 0
	MOVWF      capturar_variable_L0+2
	MOVF       R0+3, 0
	MOVWF      capturar_variable_L0+3
;KKeyPad_LCD.c,28 :: 		if (temp2==0)variable = temp1;
	MOVF       _temp2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_capturar0
	MOVF       _temp1+0, 0
	MOVWF      R0+0
	CALL       _Byte2Double+0
	MOVF       R0+0, 0
	MOVWF      capturar_variable_L0+0
	MOVF       R0+1, 0
	MOVWF      capturar_variable_L0+1
	MOVF       R0+2, 0
	MOVWF      capturar_variable_L0+2
	MOVF       R0+3, 0
	MOVWF      capturar_variable_L0+3
L_capturar0:
;KKeyPad_LCD.c,29 :: 		return variable;
	MOVF       capturar_variable_L0+0, 0
	MOVWF      R0+0
	MOVF       capturar_variable_L0+1, 0
	MOVWF      R0+1
	MOVF       capturar_variable_L0+2, 0
	MOVWF      R0+2
	MOVF       capturar_variable_L0+3, 0
	MOVWF      R0+3
;KKeyPad_LCD.c,30 :: 		}
	RETURN
; end of _capturar

_main:

;KKeyPad_LCD.c,32 :: 		void main() {
;KKeyPad_LCD.c,33 :: 		cnt = 0;                                 // Reset counter
	CLRF       _cnt+0
;KKeyPad_LCD.c,34 :: 		Keypad_Init();                           // Initialize Keypad
	CALL       _Keypad_Init+0
;KKeyPad_LCD.c,35 :: 		ANSEL  = 0;                              // Configure AN pins as digital I/O
	CLRF       ANSEL+0
;KKeyPad_LCD.c,36 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;KKeyPad_LCD.c,37 :: 		Lcd_Init();                              // Initialize LCD
	CALL       _Lcd_Init+0
;KKeyPad_LCD.c,38 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;KKeyPad_LCD.c,39 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;KKeyPad_LCD.c,40 :: 		Lcd_Out(1, 1, "1");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_KKeyPad_LCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;KKeyPad_LCD.c,41 :: 		Lcd_Out(1, 1, "Key  :");                 // Write message text on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_KKeyPad_LCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;KKeyPad_LCD.c,42 :: 		Lcd_Out(2, 1, "Times:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_KKeyPad_LCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;KKeyPad_LCD.c,44 :: 		do {
L_main1:
;KKeyPad_LCD.c,45 :: 		kp = 0;                                // Reset key code variable
	CLRF       _kp+0
;KKeyPad_LCD.c,48 :: 		kp = Keypad_Key_Click();             // Store key code in kp variable
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;KKeyPad_LCD.c,51 :: 		switch (kp) {
	GOTO       L_main4
;KKeyPad_LCD.c,52 :: 		case  1: kp = 55; oldstate=7; break; // 7        // Uncomment this block for keypad4x4
L_main6:
	MOVLW      55
	MOVWF      _kp+0
	MOVLW      7
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,53 :: 		case  2: kp = 56; oldstate=8; break; // 8
L_main7:
	MOVLW      56
	MOVWF      _kp+0
	MOVLW      8
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,54 :: 		case  3: kp = 57; oldstate=9; break; // 9
L_main8:
	MOVLW      57
	MOVWF      _kp+0
	MOVLW      9
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,55 :: 		case  4: kp = 'E'; break; // ENTER
L_main9:
	MOVLW      69
	MOVWF      _kp+0
	GOTO       L_main5
;KKeyPad_LCD.c,56 :: 		case  5: kp = 52; oldstate=4; break; // 4
L_main10:
	MOVLW      52
	MOVWF      _kp+0
	MOVLW      4
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,57 :: 		case  6: kp = 53; oldstate=5; break; // 5
L_main11:
	MOVLW      53
	MOVWF      _kp+0
	MOVLW      5
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,58 :: 		case  7: kp = 54; oldstate=6; break; // 6
L_main12:
	MOVLW      54
	MOVWF      _kp+0
	MOVLW      6
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,59 :: 		case  8: kp = 'x'; break; // x
L_main13:
	MOVLW      120
	MOVWF      _kp+0
	GOTO       L_main5
;KKeyPad_LCD.c,60 :: 		case  9: kp = 49; oldstate=1; break; // 1
L_main14:
	MOVLW      49
	MOVWF      _kp+0
	MOVLW      1
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,61 :: 		case 10: kp = 50; oldstate=2; break; // 2
L_main15:
	MOVLW      50
	MOVWF      _kp+0
	MOVLW      2
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,62 :: 		case 11: kp = 51; oldstate=3; break; // 3
L_main16:
	MOVLW      51
	MOVWF      _kp+0
	MOVLW      3
	MOVWF      _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,63 :: 		case 12: kp = '-'; break; // -
L_main17:
	MOVLW      45
	MOVWF      _kp+0
	GOTO       L_main5
;KKeyPad_LCD.c,64 :: 		case 13: kp = 'C'; break; // C
L_main18:
	MOVLW      67
	MOVWF      _kp+0
	GOTO       L_main5
;KKeyPad_LCD.c,65 :: 		case 14: kp = 48; oldstate=0; break; // 0
L_main19:
	MOVLW      48
	MOVWF      _kp+0
	CLRF       _oldstate+0
	GOTO       L_main5
;KKeyPad_LCD.c,66 :: 		case 15: kp = '='; break; // =
L_main20:
	MOVLW      61
	MOVWF      _kp+0
	GOTO       L_main5
;KKeyPad_LCD.c,67 :: 		case 16: kp = '+'; break; // +
L_main21:
	MOVLW      43
	MOVWF      _kp+0
	GOTO       L_main5
;KKeyPad_LCD.c,68 :: 		}
L_main4:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main6
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main7
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_main8
	MOVF       _kp+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_main9
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_main10
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_main11
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_main12
	MOVF       _kp+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_main13
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_main14
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_main15
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_main16
	MOVF       _kp+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_main17
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_main19
	MOVF       _kp+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_main20
	MOVF       _kp+0, 0
	XORLW      16
	BTFSC      STATUS+0, 2
	GOTO       L_main21
L_main5:
;KKeyPad_LCD.c,70 :: 		if (kp!='E') {
	MOVF       _kp+0, 0
	XORLW      69
	BTFSC      STATUS+0, 2
	GOTO       L_main22
;KKeyPad_LCD.c,71 :: 		if (temp1==0) temp1=oldstate;
	MOVF       _temp1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main23
	MOVF       _oldstate+0, 0
	MOVWF      _temp1+0
	GOTO       L_main24
L_main23:
;KKeyPad_LCD.c,72 :: 		else temp2=oldstate;
	MOVF       _oldstate+0, 0
	MOVWF      _temp2+0
L_main24:
;KKeyPad_LCD.c,73 :: 		}
L_main22:
;KKeyPad_LCD.c,75 :: 		if (kp=='E') {
	MOVF       _kp+0, 0
	XORLW      69
	BTFSS      STATUS+0, 2
	GOTO       L_main25
;KKeyPad_LCD.c,76 :: 		switch (cnt) {
	GOTO       L_main26
;KKeyPad_LCD.c,77 :: 		case  0: cnt++; variable1 = capturar(); break;
L_main28:
	INCF       _cnt+0, 1
	CALL       _capturar+0
	MOVF       R0+0, 0
	MOVWF      _variable1+0
	MOVF       R0+1, 0
	MOVWF      _variable1+1
	MOVF       R0+2, 0
	MOVWF      _variable1+2
	MOVF       R0+3, 0
	MOVWF      _variable1+3
	GOTO       L_main27
;KKeyPad_LCD.c,78 :: 		case  1: cnt++; break;
L_main29:
	INCF       _cnt+0, 1
	GOTO       L_main27
;KKeyPad_LCD.c,79 :: 		case  2: cnt=0; variable2 = capturar(); break;
L_main30:
	CLRF       _cnt+0
	CALL       _capturar+0
	MOVF       R0+0, 0
	MOVWF      _variable2+0
	MOVF       R0+1, 0
	MOVWF      _variable2+1
	MOVF       R0+2, 0
	MOVWF      _variable2+2
	MOVF       R0+3, 0
	MOVWF      _variable2+3
	GOTO       L_main27
;KKeyPad_LCD.c,80 :: 		}
L_main26:
	MOVF       _cnt+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main28
	MOVF       _cnt+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_main29
	MOVF       _cnt+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_main30
L_main27:
;KKeyPad_LCD.c,81 :: 		}
L_main25:
;KKeyPad_LCD.c,87 :: 		Lcd_Chr(1, 10, kp);                    // Print key ASCII value on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _kp+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;KKeyPad_LCD.c,89 :: 		if (cnt == 255) {                      // If counter varialble overflow
	MOVF       _cnt+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;KKeyPad_LCD.c,90 :: 		cnt = 0;
	CLRF       _cnt+0
;KKeyPad_LCD.c,91 :: 		Lcd_Out(2, 10, "   ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_KKeyPad_LCD+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;KKeyPad_LCD.c,92 :: 		}
L_main31:
;KKeyPad_LCD.c,94 :: 		WordToStr(cnt, txt);                   // Transform counter value to string
	MOVF       _cnt+0, 0
	MOVWF      FARG_WordToStr_input+0
	CLRF       FARG_WordToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;KKeyPad_LCD.c,95 :: 		Lcd_Out(2, 10, txt);                   // Display counter value on LCD
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;KKeyPad_LCD.c,97 :: 		} while (1);
	GOTO       L_main1
;KKeyPad_LCD.c,98 :: 		}
	GOTO       $+0
; end of _main
