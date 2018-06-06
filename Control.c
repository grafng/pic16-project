/************************************************************
Control.c � ��������� ���������� ������������������ ��������
************************************************************/


/* ����������� ���������� ���������� */


//������������� ������� ���
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
int flag_shim  = 1;


sbit X1 at RC3_bit;                    //������� ���������� X1 �� ����� ����� RC3
sbit X2 at RC4_bit;                    //������� ���������� X2 �� ����� ����� RC4
sbit X3 at RC5_bit;                                  //������� ���������� X3 �� ����� ����� RC5
sbit X4 at RC6_bit;                                 //������� ���������� X4 �� ����� ����� RC6
sbit X5 at RC7_bit;                                   //������� ���������� X5 �� ����� ����� RC7
sbit Y1 at RE0_bit;                            //������� ���������� Y1 �� ����� ����� RE0
sbit Y2 at RE1_bit;                               //������� ���������� Y2 �� ����� ����� RE1
sbit Y3 at RE2_bit;                                       //������� ���������� Y3 �� ����� ����� RE2

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



void interrupt()                //�������-���������� ���������� �� TMR0 � INT
{


    if( INTF == 1 )                                                     //���� ������ ���������� �� INT
    {

        flag1 = 1;

        PORTB.B1 = 1;                       // �������� ���������
        Delay_ms(50);                    // �������� �� 500 ��
        PORTB.B1 = 0;                       // ��������� ���������
        Delay_ms(50);
        INTCON = 0;

    }
    //INTF_bit = 0;



    counter++;
    if(counter == 100)                                                          //���� ������ ����� ������ 1,8 �
    {
        flag_T = 1;                                                //���������� ���� ��������� �������
        //�������       ���� = 0.75 �
        counter = 0;
    }
    TMR0 = 44;                                                                   //������������� ������
    T0IF_bit = 0;                                                         //�������� ���� ������� ���������� T0IF



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

        Lcd_Cmd(_LCD_CLEAR);          // �������� ���
        Lcd_Out(1, 5, "ERROR");           // ����� �� �������
        // ��������� �� ������
        Sound_Play(500,10000);          // ����� ��������� �������
        // ������� 500 �� ������������� 10 ������
        while (1)              // ����� ��������� ��������� �������  �
        {                                                     // ������������ ���������
            PORTB.B1 = 1;                       // �������� ���������
            Delay_ms(5);                    // �������� �� 500 ��
            PORTB.B1 = 0;                       // ��������� ���������
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




        //        PORTB.B1 = 1;                       // �������� ���������
        //        Delay_ms(1);                    // �������� �� 500 ��
        //        PORTB.B1 = 0;                       // ��������� ���������
        //        Delay_ms(1);
        goto again;
    }
}














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

    bit f;                                        //������� ���������� ��� �������� ����������
    //���������� ���������� �������

    f = (!( (!X1) && (!X5) && (!X3) )) || (!X2) || (!X4);         //���������� �������

    if ( f == 1 )                                      //���� ��������� ����� 1
    {
        Y1=1;
        Delay_us(70);
        Y1=0;
    }

}



void analog()
{

    int g;                                                        //����������� ���������� ��� ��������
    int e;                                                        //����������� ����������
    int h;                                                                //������� g(), e(), h()
    char DC1;                                                //���������� ��� �������� ����� ���

    //������ ����� ���
    W1 = ADC_Read(0);                                //���������� ����� 0 (������ U1)
    W2 = ADC_Read(1);                                //���������� ����� 0 (������ U2)
    W3 = ADC_Read(2);                                 //���������� ����� 0 (������ U3)
    W4 = ADC_Read(3);                                 //���������� ����� 0 (������ U4)
    W5 = ADC_Read(4);                                 //���������� ����� 0 (������ U5)

    g = 5*W1 + 2*K2 - ( 3*W3 + K1 ) / K3;   //���������� ������� g()


    if ( g >= Q )
    {
        Y3=1;                                              //����� ������� Y3
        Delay_ms(23);
        Y3=0;
    }
    else
    {
        Y2 = 1;
        Delay_ms(18);
        Y2 = 0;
    }


    h = W5 / K5;                              //���������� ������� h()  
    e = W4 / (2*K4);

    //    if ( flag_shim == 1 )

    DC1 = h;                                                          //���������� �������� �������� �����
    PWM1_Set_Duty(DC1);                                  //���������� ������� ������� ���� ��� //PWM2


                                               //���������� ������� e()

    //    if ( flag_shim == 0 )
    //    {
    DC1 = e;                                                        //���������� �������� �������� �����
    PWM2_Set_Duty(DC1);                        //���������� ������� ������� ���� ��� //PWM1
    //    }

}




void display()
{

    int mvolts;                          //���������� ��� �������� �������� ���������� �
    //������������
    char num;                                           //���������� ��� �������� ���� ���������� �
    //�������
    switch (key)
    {
    case 1:
    {
        mvolts = ((long)W1*5000) / 0x03FF;                     //��������������
        //���� W1 � �����������
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U1=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                         // ����� ����� � ���� ASCII
        Lcd_Chr_Cp('.');                                      //����� �� ��� ���������� �����
        num = (mvolts / 100) % 10;                             //���������� ������� ����� ������
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //� ������� ������� �������
        break;
    }
    case 2:
    {
        mvolts = ((long)W2*5000) / 0x03FF;                             //�������������� ���� W2 � �����������
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U2=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                            // ����� ����� � ���� ASCII
        Lcd_Chr_Cp('.');                                                  //����� �� ��� ���������� �����
        num = (mvolts / 100) % 10;                             //���������� ������� ����� ������
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //� ������� ������� �������
        break;
    }
    case 3:
    {
        mvolts = ((long)W3*5000) / 0x03FF;                             //�������������� ���� W3 � �����������
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U3=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                        // ����� ����� � ���� ASCII
        Lcd_Chr_Cp('.');                                           //����� �� ��� ���������� �����
        num = (mvolts / 100) % 10;                      //���������� ������� ����� ������
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //� ������� ������� �������
        break;
    }
    case 5:
    {
        mvolts = ((long)W4*5000) / 0x03FF;                             //�������������� ���� W4 � �����������
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U4=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                          // ����� ����� � ���� ASCII
        Lcd_Chr_Cp('.');                                                //����� �� ��� ���������� �����
        num = (mvolts / 100) % 10;                                     //���������� ������� ����� ������
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //� ������� ������� �������
        break;
    }
    case 6:
    {
        mvolts = ((long)W5*5000) / 0x03FF;                             //�������������� ���� W5 � �����������
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U5=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                        // ����� ����� � ���� ASCII
        Lcd_Chr_Cp('.');                                                 //����� �� ��� ���������� �����
        num = (mvolts / 100) % 10;                                   //���������� ������� ����� ������
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //� ������� ������� �������
        break;
    }

    case 7:
    {


        flag_T = 1;
        flag_shim = (!flag_shim);
        PORTB.B1 = 1;                       // �������� ���������
        Delay_ms(1);                    // �������� �� 500 ��
        PORTB.B1 = 0;                       // ��������� ���������
        Delay_ms(1);


    }




    }

}
