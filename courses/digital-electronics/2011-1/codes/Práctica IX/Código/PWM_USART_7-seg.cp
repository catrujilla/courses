#line 1 "C:/Users/Calelo/Desktop/Práctica IX/Código/PWM_USART_7-seg.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/built_in.h"
#line 2 "C:/Users/Calelo/Desktop/Práctica IX/Código/PWM_USART_7-seg.c"
unsigned int estado_PWM;
unsigned int temp_res, voltaje_mV;
unsigned short current_duty;
signed long long_current_duty;
unsigned char led;
char txt[7];
char voltaje[6];

void interrupt() {
 if (PIR1.RCIF) {
 led = UART1_Read();

 if (led=='A') {
 if (estado_PWM==1){
 PWM1_Stop();
 estado_PWM = 0;
 goto salir;
 }
 if (estado_PWM==0){
 PWM1_Start();
 estado_PWM = 1;
 }
#line 37 "C:/Users/Calelo/Desktop/Práctica IX/Código/PWM_USART_7-seg.c"
 salir:
 asm nop;
 }
 PIR1.RCIF = 0;
 }
}

void main() {
 ANSEL = 0x04;
 TRISA = 0xFF;
 ANSELH = 0;
 TRISB = 0x00;
 TRISC.RC1 = 0;
 PORTC.RC1 = 0;
 PORTB = 0x00;
 INTCON = 0B11000000;
 UART1_Init(115200);
 PIE1.RCIE = 1;
 delay_ms(100);

 PWM1_Init(5000);
 current_duty = 127;
 PWM1_Start();
 PWM1_Set_Duty(current_duty);

 estado_PWM = 1;

 do {
 temp_res = ADC_Read(2);

 voltaje_mV = temp_res*(4.88758);
 IntToStr(voltaje_mV,txt);
 UART1_Write_Text(txt),UART1_Write_Text("mV"),UART1_Write(10),UART1_Write(13) ;

 long_current_duty = ((12.14)*temp_res) - 485.7142;
 if (long_current_duty<0) long_current_duty=0;
 if (long_current_duty>255) long_current_duty=255;
 current_duty = long_current_duty;
 PWM1_Set_Duty(current_duty);

 } while(1);
}
