#line 1 "G:/Electrónica/Taller V IF 2011-01/Prácticas/Códigos y Simulaciones/Práctica X/Código/SPI_DAC_LCD.c"

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



sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;


unsigned int value,datos_enviados,mV,a,b;

char txt1[] = "Carlos Trujillo";
char txt2[] = "SPI-DAC";
char txt[7];

char i;


void DAC_Output(unsigned int valueDAC) {
 char temp;

 Chip_Select = 0;


 temp = (valueDAC >> 8) & 0x0F;
 temp |= 0x30;
 SPI1_Write(temp);


 temp = valueDAC;
 SPI1_Write(temp);

 Chip_Select = 1;
}
void visualizar_LCD() {

 IntToStr(value,txt);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Dato: ");
 Lcd_Out(1,7,txt);

 IntToStr(datos_enviados,txt);
 Lcd_Out(2,1,"Dato # :");
 Lcd_Out(2,9,txt);
}
void main(){
 ANSEL = 0;
 ANSELH = 0;
 C1ON_bit = 0;
 C2ON_bit = 0;

 TRISA0_bit = 1;
 TRISA1_bit = 1;
 Chip_Select = 1;
 Chip_Select_Direction = 0;
 SPI1_Init();

 value = 2048;


 datos_enviados = 0;

 DAC_Output(value);

 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,txt1);

 Lcd_Out(2,6,txt2);
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);

 visualizar_LCD();


 while(1) {
 if (RA0_bit==0) a=1;
 if ((RA0_bit) && (value < 4095) && a==1) {
 value++;
 datos_enviados++;
 visualizar_LCD();
 a=0;
 }

 if (RA1_bit==0) b=1;
 if ((RA1_bit) && (value > 0) && b==1) {
 value--;
 datos_enviados++;
 visualizar_LCD();
 b=0;
 }

 DAC_Output(value);

 Delay_ms(1);


 }
}
