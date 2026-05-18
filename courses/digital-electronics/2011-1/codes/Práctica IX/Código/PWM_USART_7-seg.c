#include <built_in.h>
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
              
              /*
      switch (estado_PWM) {
       case 1:
            PWM1_Stop();
            estado_PWM = 0;
            break;
       case 0:
            PWM1_Start();
            estado_PWM = 1;
            break;
            }
            */
            salir:
            asm nop;
   }
   PIR1.RCIF = 0;  //sALGA DE ESTA INTERRUPCIÓN
  }
}

void main() {
  ANSEL  = 0x04;              // Configure AN2 pin as analog
  TRISA  = 0xFF;              // PORTA is input
  ANSELH = 0;                 // Configure other AN pins as digital I/O
  TRISB  = 0x00;              // Salidas
  TRISC.RC1 = 0;
  PORTC.RC1 = 0;
  PORTB  = 0x00;
  INTCON = 0B11000000;        //Sólo GIE y PIE
  UART1_Init(115200);
  PIE1.RCIE = 1;               //aCTIVA iNTERRUPCIÓN POR RECEPCION
  delay_ms(100);
  
  PWM1_Init(5000);                    // Initialize PWM1 module at 5KHz
  current_duty  = 127;                 // initial value for current_duty 50%
  PWM1_Start();                       // start PWM1
  PWM1_Set_Duty(current_duty);        // Set current duty for PWM1
  
  estado_PWM = 1;

  do {
    temp_res = ADC_Read(2);   // Get 10-bit results of AD conversion

    voltaje_mV = temp_res*(4.88758);
    IntToStr(voltaje_mV,txt);
    UART1_Write_Text(txt),UART1_Write_Text("mV"),UART1_Write(10),UART1_Write(13) ;

    long_current_duty = ((12.14)*temp_res) - 485.7142;
    if (long_current_duty<0) long_current_duty=0;
    if (long_current_duty>255) long_current_duty=255;
    current_duty = long_current_duty;
    PWM1_Set_Duty(current_duty);        // Set current duty for PWMM

  } while(1);
}

