#line 1 "C:/Users/qwerty/Desktop/курсач 2018/program backup3/Control.c"
#line 10 "C:/Users/qwerty/Desktop/курсач 2018/program backup3/Control.c"
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

char keypadPort at PORTD;
char key;
char counter = 0;
char flag_T = 0;
char flag1 = 0;
int flag_shim = 1;


sbit X1 at RC3_bit;
sbit X2 at RC4_bit;
sbit X3 at RC5_bit;
sbit X4 at RC6_bit;
sbit X5 at RC7_bit;
sbit Y1 at RE0_bit;
sbit Y2 at RE1_bit;
sbit Y3 at RE2_bit;

unsigned int W1;
unsigned int W2;
unsigned int W3;
unsigned int W4;
unsigned int W5;

const code int K1 = 20;
const code int K2 = 8;
const code int K3 = 15;
const code int K4 = 40;
const code int K5 = 12;
const code int Q = 55;

void interrupt();
void init();
void digit();
void analog();
void display();



void interrupt()
{


 if( INTF == 1 )
 {

 flag1 = 1;

 PORTB.B1 = 1;
 Delay_ms(50);
 PORTB.B1 = 0;
 Delay_ms(50);
 INTCON = 0;

 }




 counter++;
 if(counter == 100)
 {
 flag_T = 1;

 counter = 0;
 }
 TMR0 = 44;
 T0IF_bit = 0;



}





void main ()
{

 init();



again:
 digit();
 analog();
opros:

 if ( flag1 == 1 )
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 5, "ERROR");

 Sound_Play(500,10000);

 while (1)
 {
 PORTB.B1 = 1;
 Delay_ms(5);
 PORTB.B1 = 0;
 Delay_ms(5);
 }


 }


 key = 0;
 key = Keypad_Key_Click();

 if (key !=0)
 {
 display();

 }

 if (flag_T == 0)
 goto opros
 else
 {
 flag_T = 0;
 counter = 0;
 TMR0 = 44;








 goto again;
 }
}
#line 173 "C:/Users/qwerty/Desktop/курсач 2018/program backup3/Control.c"
void init()
{

 TRISA = 0xFF;
 TRISB = 0b11111101;
 TRISC = 0b11111000;
 TRISE = 0;
 TRISD = 0xFF;
 PORTE = 0;
 PORTB.B1 = 0;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,4, "Work Mode");
 ADC_Init();
 Keypad_Init();

 PWM1_Init(40000);
 PWM2_Init(40000);

 PWM1_Start();
 PWM2_Start();


 Sound_Init(&PORTC,0);
 OPTION_REG = 0b00101010;
 TMR0 = 44;
 INTCON = 0xB0;
 flag1 = 0;

}



void digit()
{

 bit f;


 f = (!( (!X1) && (!X5) && (!X3) )) || (!X2) || (!X4);

 if ( f == 1 )
 {
 Y1=1;
 Delay_us(70);
 Y1=0;
 }

}



void analog()
{

 int g;
 int e;
 int h;
 char DC1;


 W1 = ADC_Read(0);
 W2 = ADC_Read(1);
 W3 = ADC_Read(2);
 W4 = ADC_Read(3);
 W5 = ADC_Read(4);

 g = 5*W1 + 2*K2 - ( 3*W3 + K1 ) / K3;


 if ( g >= Q )
 {
 Y3=1;
 Delay_ms(23);
 Y3=0;
 }
 else
 {
 Y2 = 1;
 Delay_ms(18);
 Y2 = 0;
 }


 h = W5 / K5;
 e = W4 / (2*K4);



 DC1 = h;
 PWM1_Set_Duty(DC1);






 DC1 = e;
 PWM2_Set_Duty(DC1);


}




void display()
{

 int mvolts;

 char num;

 switch (key)
 {
 case 1:
 {
 mvolts = ((long)W1*5000) / 0x03FF;

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,4, "Work Mode");
 Lcd_Out(2,4, "U1=");
 num = mvolts / 1000;
 Lcd_Chr_Cp(48+num);
 Lcd_Chr_Cp('.');
 num = (mvolts / 100) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Out_Cp("V");
 break;
 }
 case 2:
 {
 mvolts = ((long)W2*5000) / 0x03FF;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,4, "Work Mode");
 Lcd_Out(2,4, "U2=");
 num = mvolts / 1000;
 Lcd_Chr_Cp(48+num);
 Lcd_Chr_Cp('.');
 num = (mvolts / 100) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Out_Cp("V");
 break;
 }
 case 3:
 {
 mvolts = ((long)W3*5000) / 0x03FF;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,4, "Work Mode");
 Lcd_Out(2,4, "U3=");
 num = mvolts / 1000;
 Lcd_Chr_Cp(48+num);
 Lcd_Chr_Cp('.');
 num = (mvolts / 100) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Out_Cp("V");
 break;
 }
 case 5:
 {
 mvolts = ((long)W4*5000) / 0x03FF;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,4, "Work Mode");
 Lcd_Out(2,4, "U4=");
 num = mvolts / 1000;
 Lcd_Chr_Cp(48+num);
 Lcd_Chr_Cp('.');
 num = (mvolts / 100) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Out_Cp("V");
 break;
 }
 case 6:
 {
 mvolts = ((long)W5*5000) / 0x03FF;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,4, "Work Mode");
 Lcd_Out(2,4, "U5=");
 num = mvolts / 1000;
 Lcd_Chr_Cp(48+num);
 Lcd_Chr_Cp('.');
 num = (mvolts / 100) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Chr_Cp(48+num);
 num = (mvolts / 10) % 10;
 Lcd_Out_Cp("V");
 break;
 }

 case 7:
 {


 flag_T = 1;
 flag_shim = (!flag_shim);
 PORTB.B1 = 1;
 Delay_ms(1);
 PORTB.B1 = 0;
 Delay_ms(1);


 }




 }

}
