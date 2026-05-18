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
       if (PORTB.RB6 ==1) desbordes=desbordes+488;  //488 desbordes son 50ms
       if (PORTB.RB7 ==1) desbordes=desbordes-488;
       if (desbordes <= 488) desbordes=489;
    INTCON.RBIF = 0;
  }
  else if (PIR1.TMR1IF) {
    contador_TMR1++;
    if (contador_TMR1 == 76){   //Un segundo
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
        temp_res = ADC_Read(4);   // Get 10-bit results of AD conversion
        IntToStr(temp_res,txt);   //Convertir binario a Ascii
        UART1_Write_Text(txt);
        UART1_Write(10),UART1_Write(13); //Enter
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
  /*
   if (dato==0){   portc=0xC0, PORTB.RB5=1;   }
   if (dato==1){   portc=0xF9, PORTB.RB5=1;   }
   if (dato==2){   PORTc=0xA4, PORTB.RB5=0;   }
   if (dato==3){   PORTc=0xB0, PORTB.RB5=0;   }
   if (dato==4){   portc=0x99, PORTB.RB5=0;   }
   if (dato==5){   portc=0x92, PORTB.RB5=0;   }
   if (dato==6){   portc=0x82, PORTB.RB5=0;   }
   if (dato==7){   portc=0xF8, PORTB.RB5=1;   }
   if (dato==8){   portc=0x80, PORTB.RB5=0;   }
   if (dato==9){   portc=0x90, PORTB.RB5=0;   }
   */
}
void main() {
  ANSEL  = 0B00010000;              // Configure AN5 pin as analog
  ANSELH = 0X00;                 // Configure other AN pins as digital I/O
  C1ON_bit = 0;               // Disable comparators
  C2ON_bit = 0;

  TRISA  = 0B00100000;              // RA5(AN4) is input
  TRISC  = 0;                 // PORTC is output
  TRISB  = 0b11000000;                 // RB7 and RB6 are outputs
  
  PORTB = PORTA = 0;
  
  OPTION_REG = 0B01000000;      //Prescaler 1:2, INT por flanco de subida, Prescaler pa' TMR0
  INTCON = 0B11111000;          //Habilitadas INT ext, RBChange, TMR0 int además de las periféricas y las globales
  IOCB = 0B11000000;            //RB6 y RB7 generan interrupción
  
  PIE1.TMR1IE = 1;      //Se habilita la interupción por Timer1
  T1CON = 0b10000001;   //Se configura el preescaler del Timer a 1:1, se utiliza el reloj interno (Timer)

  /*      Inicialización USART */
  UART1_INIT(115200);
  Delay_ms(10);
  UART1_Write_text("Junior");

/*      Inicialización de variables    */
  contador_TMR0 = 0;
  contador_TMR1 = 0;
  envio_ADC = 0;
  desbordes = 9766; //9766 desbordes del TMR0 a 1:2 da aprox. 1seg
  dato_1 = 0;
  dato_2 = 0;
  i = 0;
  PORTC=0xC0;  // INICIALIZACIÓN DEL PUERTO A EN CERO DE 7-SEGMENTOS
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
        
   PORTB.RB2 =1,   PORTB.RB1 =0;
   visualizar(dato_1);
   delay_ms(30);
   
   PORTB.RB2 =0,   PORTB.RB1 =1;
   visualizar(dato_2);
   delay_ms(30);
   
  } while(729);

}