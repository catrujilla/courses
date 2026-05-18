#line 1 "G:/Electrónica/Taller V IF 2011-01/Prácticas/Códigos y Simulaciones/Práctica X/KeyPad_LCD/KKeyPad_LCD.c"
unsigned short kp, cnt, oldstate, temp1, temp2, operacion;
char txt[6];
float variable1, variable2, resultado;
bit mostrar = 0;


char keypadPort at PORTC;



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


void efectuar () {
 switch (operacion) {
 case '+':
 resultado = (variable1+variable2);
 break;
 case '-':
 resultado = (variable1-variable2);
 break;
 case 'x':
 resultado = (variable1*variable2);
 break;
 case '/':
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
 cnt = 0;
 Keypad_Init();
 ANSEL = 0;
 ANSELH = 0;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1, 1, "1");
 Lcd_Out(1, 1, "Key  :");
 Lcd_Out(2, 1, "Times:");

 do {
 kp = 0;


 kp = Keypad_Key_Click();


 switch (kp) {
 case 1: kp = 55; oldstate=7; break;
 case 2: kp = 56; oldstate=8; break;
 case 3: kp = 57; oldstate=9; break;
 case 4: kp = '/'; break;
 case 5: kp = 52; oldstate=4; break;
 case 6: kp = 53; oldstate=5; break;
 case 7: kp = 54; oldstate=6; break;
 case 8: kp = 'x'; break;
 case 9: kp = 49; oldstate=1; break;
 case 10: kp = 50; oldstate=2; break;
 case 11: kp = 51; oldstate=3; break;
 case 12: kp = '-'; break;
 case 13: kp = 'C'; break;
 case 14: kp = 48; oldstate=0; break;
 case 15: kp = '='; break;
 case 16: kp = '+'; break;
 }

 if (kp!='C') {
 if (temp1==0) temp1=oldstate;
 else temp2=oldstate;
 }

 if (kp=='C') {
 switch (cnt) {
 case 0: cnt++; variable1 = capturar(); break;
 case 1:
 cnt++;
 operacion = kp;
 break;
 case 2:
 cnt=0;
 variable2 = capturar();
 efectuar();
 mostrar = 1;
 break;
 }
 }

 if (mostrar== 1) {

 }



 Lcd_Chr(1, 10, kp);

 if (cnt == 255) {
 cnt = 0;
 Lcd_Out(2, 10, "   ");
 }

 WordToStr(cnt, txt);
 Lcd_Out(2, 10, txt);

 } while (1);
}
