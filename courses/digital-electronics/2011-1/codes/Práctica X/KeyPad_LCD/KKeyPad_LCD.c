unsigned short kp, cnt, oldstate, temp1, temp2, operacion;
char txt[6];
float variable1, variable2, resultado;
bit mostrar = 0;

// Keypad module connections
char  keypadPort at PORTC;
// End Keypad module connections

// LCD module connections
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;
// End LCD module connections

void efectuar () {
    switch (operacion) {
      case  '+': 
            resultado = (variable1+variable2); 
            break;
      case  '-': 
            resultado = (variable1-variable2); 
            break;
      case  'x': 
            resultado = (variable1*variable2); 
            break;
      case  '/': 
            resultado = (variable1/variable2); 
            break;
    }
}

capturar () {
float variable;
variable = (temp1*10) + temp2;
if (temp2==0)variable = temp1;
return variable;
}

void main() {
  cnt = 0;                                 // Reset counter
  Keypad_Init();                           // Initialize Keypad
  ANSEL  = 0;                              // Configure AN pins as digital I/O
  ANSELH = 0;
  Lcd_Init();                              // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);                     // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);                // Cursor off
  Lcd_Out(1, 1, "1");
  Lcd_Out(1, 1, "Key  :");                 // Write message text on LCD
  Lcd_Out(2, 1, "Times:");
  
  do {
    kp = 0;                                // Reset key code variable

    // Wait for key to be pressed and released
    kp = Keypad_Key_Click();             // Store key code in kp variable

    // Prepare value for output, transform key to it's ASCII value
    switch (kp) {
      case  1: kp = 55; oldstate=7; break; // 7        // Uncomment this block for keypad4x4
      case  2: kp = 56; oldstate=8; break; // 8
      case  3: kp = 57; oldstate=9; break; // 9
      case  4: kp = '/'; break; // ENTER
      case  5: kp = 52; oldstate=4; break; // 4
      case  6: kp = 53; oldstate=5; break; // 5
      case  7: kp = 54; oldstate=6; break; // 6
      case  8: kp = 'x'; break; // x
      case  9: kp = 49; oldstate=1; break; // 1
      case 10: kp = 50; oldstate=2; break; // 2
      case 11: kp = 51; oldstate=3; break; // 3
      case 12: kp = '-'; break; // -
      case 13: kp = 'C'; break; // C
      case 14: kp = 48; oldstate=0; break; // 0
      case 15: kp = '='; break; // =
      case 16: kp = '+'; break; // +
    }
    
    if (kp!='C') {
       if (temp1==0) temp1=oldstate;
       else temp2=oldstate;
    }
    
    if (kp=='C') {
       switch (cnt) {
              case  0: cnt++; variable1 = capturar(); break;
              case  1: 
              cnt++; 
              operacion = kp;
              break;
              case  2: 
                    cnt=0; 
                    variable2 = capturar(); 
                    efectuar(); 
                    mostrar = 1; 
                    break;
              }
    }
    
   if (mostrar== 1) {

   }
    


    Lcd_Chr(1, 10, kp);                    // Print key ASCII value on LCD

    if (cnt == 255) {                      // If counter varialble overflow
      cnt = 0;
      Lcd_Out(2, 10, "   ");
      }

    WordToStr(cnt, txt);                   // Transform counter value to string
    Lcd_Out(2, 10, txt);                   // Display counter value on LCD
    
  } while (1);
}