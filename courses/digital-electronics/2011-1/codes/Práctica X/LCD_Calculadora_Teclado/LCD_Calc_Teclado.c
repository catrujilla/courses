unsigned short kp, oldstate, operacion;
char txt[15];
float variable1, variable2, resultado;
short numero[10];
short i = 8;
short j = 1;
int entero;

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
    switch (kp) {
      case  '+': resultado = (variable1+variable2); break;
      case  '-': resultado = (variable1-variable2); break;
      case  'x': resultado = (variable1*variable2); break;
      case  '/': resultado = (variable1/variable2); break;
    }
}

void main() {
  Keypad_Init();                           // Initialize Keypad
  ANSEL  = 0;                              // Configure AN pins as digital I/O
  ANSELH = 0;
  Lcd_Init();                              // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);                     // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Out(1, 1, "   Calculadora");
  Lcd_Out(2, 1, "     C.A.T.A");
  delay_ms(1000);

  while (1) {
    Lcd_Cmd(_LCD_CLEAR);                     // Clear display
    Lcd_Out(1, 1, "    Primer #?");
    
    Numero1:
    kp=0;
    // Wait for key to be pressed and released
    do kp = Keypad_Key_Click();             // Store key code in kp variable
     while (!kp);
    
    switch (kp) {
      case  1: kp = 55; oldstate=7; break; // 7        // Uncomment this block for keypad4x4
      case  2: kp = 56; oldstate=8; break; // 8
      case  3: kp = 57; oldstate=9; break; // 9
      case  5: kp = 52; oldstate=4; break; // 4
      case  6: kp = 53; oldstate=5; break; // 5
      case  7: kp = 54; oldstate=6; break; // 6
      case  9: kp = 49; oldstate=1; break; // 1
      case 10: kp = 50; oldstate=2; break; // 2
      case 11: kp = 51; oldstate=3; break; // 3
      case 13: kp = 'C'; break; // C
      case 14: kp = 48; oldstate=0; break; // 0
      default : goto Numero1;
      }

    Lcd_Chr(2, i, kp);
    numero[j]=oldstate;
    i++;
    j++;
    if (kp != 'C') goto Numero1;
    if (j==3) variable1 = numero[1];
    if (j==4) variable1 = numero[1]*10 + numero[2];
    if (j==5) variable1 = numero[1]*100 + numero[2]*10 + numero[3];
    if (j==6) variable1 = numero[1]*1000 + numero[2]*100 + numero[3]*10 + numero[4];
    numero[2] = 0;numero[1] = 0; numero[3] = 0;
    i=8;
    j=1;
    
   Lcd_Cmd(_LCD_CLEAR);                     // Clear display
   Lcd_Out(1, 1, "   Segundo #?");

   Numero2:
   kp=0;
   // Wait for key to be pressed and released
    do kp = Keypad_Key_Click();             // Store key code in kp variable
     while (!kp);
   
    switch (kp) {
      case  1: kp = 55; oldstate=7; break; // 7        // Uncomment this block for keypad4x4
      case  2: kp = 56; oldstate=8; break; // 8
      case  3: kp = 57; oldstate=9; break; // 9
      case  5: kp = 52; oldstate=4; break; // 4
      case  6: kp = 53; oldstate=5; break; // 5
      case  7: kp = 54; oldstate=6; break; // 6
      case  9: kp = 49; oldstate=1; break; // 1
      case 10: kp = 50; oldstate=2; break; // 2
      case 11: kp = 51; oldstate=3; break; // 3
      case 13: kp = 'C'; break; // C
      case 14: kp = 48; oldstate=0; break; // 0
      default : goto Numero2;
    }
    
    Lcd_Chr(2, i, kp);
    numero[j]=oldstate;
    i++;
    j++;
    if (kp != 'C') goto Numero2;
    if (j==3) variable2 = numero[1];
    if (j==4) variable2 = numero[1]*10 + numero[2];
    if (j==5) variable2 = numero[1]*100 + numero[2]*10 + numero[3];
    if (j==6) variable2 = numero[1]*1000 + numero[2]*100 + numero[3]*10 + numero[4];
    numero[1] = 0;numero[3] = 0; numero[2] = 0;
    i=8;
    j=1;
    
    operacion_:
    kp=0;
    Lcd_Cmd(_LCD_CLEAR);                     // Clear display
    Lcd_Out(1, 1, "   Operacion?");
    
    // Wait for key to be pressed and released
    do kp = Keypad_Key_Click();             // Store key code in kp variable
     while (!kp);

     switch (kp){
      case  4: kp = '/'; Lcd_Chr(2, i, kp); efectuar(); break; // /
      case  8: kp = 'x'; Lcd_Chr(2, i, kp); efectuar(); break; // x
      case 12: kp = '-'; Lcd_Chr(2, i, kp); efectuar(); break; // -
      case 16: kp = '+'; Lcd_Chr(2, i, kp); efectuar(); break; // +
      default :
              Lcd_Out(2, 1, "Escoja Operacion");
              delay_ms(1000);
              goto operacion_;
        }
       delay_ms(300);

     //Resultado
    Lcd_Cmd(_LCD_CLEAR);                     // Clear display
    Lcd_Out(1, 1, "   Resultado:");
    FloatToStr(resultado, txt);
    Lcd_Out(2, 4, txt);
     
   delay_ms(3000);

   //Ahora se reinicia...
  }
}