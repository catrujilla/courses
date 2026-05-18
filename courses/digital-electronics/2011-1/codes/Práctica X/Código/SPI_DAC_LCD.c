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

// DAC module connections
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
// End DAC module connections

unsigned int value,datos_enviados,mV,a,b;

char txt1[] = "Carlos Trujillo";
char txt2[] = "SPI-DAC";
char txt[7];

char i;                              // Loop variable

// DAC increments (0..4095) --> output voltage (0..Vref)
void DAC_Output(unsigned int valueDAC) {
  char temp;

  Chip_Select = 0;                       // Select DAC chip

  // Send High Byte
  temp = (valueDAC >> 8) & 0x0F;         // Store valueDAC[11..8] to temp[3..0]
  temp |= 0x30;                          // Define DAC setting, see MCP4921 datasheet
  SPI1_Write(temp);                      // Send high byte via SPI

  // Send Low Byte
  temp = valueDAC;                       // Store valueDAC[7..0] to temp[7..0]
  SPI1_Write(temp);                      // Send low byte via SPI

  Chip_Select = 1;                       // Deselect DAC chip
}
void visualizar_LCD() {
      //mV=value*1.2207;
      IntToStr(value,txt);
      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(1,1,"Dato: ");
      Lcd_Out(1,7,txt);
      //Lcd_Out(1,15,"mV");
      IntToStr(datos_enviados,txt);
      Lcd_Out(2,1,"Dato # :");
      Lcd_Out(2,9,txt);
}
void main(){
  ANSEL  = 0;                        // Configure AN pins as digital I/O
  ANSELH = 0;
  C1ON_bit = 0;                      // Disable comparators
  C2ON_bit = 0;
  
  TRISA0_bit = 1;                        // Set RA0 pin as input
  TRISA1_bit = 1;                        // Set RA1 pin as input
  Chip_Select = 1;                       // Deselect DAC
  Chip_Select_Direction = 0;             // Set CS# pin as Output
  SPI1_Init();                           // Initialize SPI module
  
  value = 2048;                          // When program starts, DAC gives
                                         //   the output in the mid-range
                                         
  datos_enviados = 0;                 //Datos enviados al DAC
  
  DAC_Output(value);
                                         
  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,1,txt1);                 // Write text in first row

  Lcd_Out(2,6,txt2);                 // Write text in second row
  Delay_ms(1000);
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  
  visualizar_LCD();


  while(1) {                         // Endless loop
      if (RA0_bit==0) a=1;
       if ((RA0_bit) && (value < 4095) && a==1) {   // If RA0 button is pressed
      value++;                           //   increment value
      datos_enviados++;
      visualizar_LCD();
      a=0;
      }
      
      if (RA1_bit==0) b=1;
      if ((RA1_bit) && (value > 0) && b==1) {    // If RA1 button is pressed
        value--;                         //   decrement value
        datos_enviados++;
        visualizar_LCD();
        b=0;
        }

    DAC_Output(value);                   // Send value to DAC chip
    
    Delay_ms(1);                         // Slow down key repeat pace


  }
}