#line 1 "E:/Electrónica/Taller V IF 2011-01/Prácticas/Códigos y Simulaciones/Práctica VIII/ADC_USART_INT_TMRX/ADC_USART_INT_TMRX.c"
unsigned int temp_res;
unsigned long contador_TMR0, desbordes, contador_TMR1;
unsigned short envio_ADC,incrementar,dato_1,dato_2,i;
char txt[7];

void interrupt() {
 if (INTCON.TMR0IF) {
 contador_TMR0++;
 if (contador_TMR0 == desbordes){
 envio_ADC = 1;
 contador_TMR0 = 0;
 }
 INTCON.TMR0IF = 0;
 }
 else if (INTCON.RBIF) {
 if (PORTB.RB6 ==1) desbordes=desbordes+488;
 if (PORTB.RB7 ==1) desbordes=desbordes-488;
 if (desbordes <= 488) desbordes=489;
 INTCON.RBIF = 0;
 }
 else if (PIR1.TMR1IF) {
 contador_TMR1++;
 if (contador_TMR1 == 76){
 incrementar = 1;
 contador_TMR1 = 0;
 }
 PIR1.TMR1IF = 0;
 }
}
void incrementar_contador () {
 i=i+1;
 if (i>99)i=0;
 dato_2 = i/10;
 dato_1 = (i - (dato_2*10));
}

void ADC_UART () {
 temp_res = ADC_Read(4);
 IntToStr(temp_res,txt);
 UART1_Write_Text(txt);
 UART1_Write(10),UART1_Write(13);
}

visualizar (unsigned short dato) {
switch (dato) {
 case 0 :
 portc=0xC0;
 PORTB.RB5=1;
 break;
 case 1 :
 portc=0xF9;
 PORTB.RB5=1;
 break;
 case 2 :
 PORTc=0xA4;
 PORTB.RB5=0;
 break;
 case 3 :
 PORTc=0xB0;
 PORTB.RB5=0;
 break;
 case 4 :
 portc=0x99;
 PORTB.RB5=0;
 break;
 case 5 :
 portc=0x92;
 PORTB.RB5=0;
 break;
 case 6 :
 portc=0x82;
 PORTB.RB5=0;
 break;
 case 7 :
 portc=0xF8;
 PORTB.RB5=1;
 break;
 case 8 :
 portc=0x80;
 PORTB.RB5=0;
 break;
 case 9 :
 portc=0x90;
 PORTB.RB5=0;
 break;
}
#line 99 "E:/Electrónica/Taller V IF 2011-01/Prácticas/Códigos y Simulaciones/Práctica VIII/ADC_USART_INT_TMRX/ADC_USART_INT_TMRX.c"
}
void main() {
 ANSEL = 0B00010000;
 ANSELH = 0X00;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISA = 0B00100000;
 TRISC = 0;
 TRISB = 0b11000000;

 PORTB = PORTA = 0;

 OPTION_REG = 0B01000000;
 INTCON = 0B11111000;
 IOCB = 0B11000000;

 PIE1.TMR1IE = 1;
 T1CON = 0b10000001;


 UART1_INIT(115200);
 Delay_ms(10);
 UART1_Write_text("Junior");


 contador_TMR0 = 0;
 contador_TMR1 = 0;
 envio_ADC = 0;
 desbordes = 9766;
 dato_1 = 0;
 dato_2 = 0;
 i = 0;
 PORTC=0xC0;
 TMR0 = 0;

 do {
 if (envio_ADC == 1) {
 ADC_UART();
 envio_ADC = 0;
 }

 if (incrementar == 1) {
 incrementar_contador();
 incrementar = 0;
 }

 PORTB.RB2 =1, PORTB.RB1 =0;
 visualizar(dato_1);
 delay_ms(30);

 PORTB.RB2 =0, PORTB.RB1 =1;
 visualizar(dato_2);
 delay_ms(30);

 } while(729);

}
