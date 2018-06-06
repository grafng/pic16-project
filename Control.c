/************************************************************
Control.c – программа управления микроконтроллерной системой
************************************************************/


/* Определения глобальных переменных */


//присоединение выводов ЖКД
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


sbit X1 at RC3_bit;                    //битовая переменная X1 на линии порта RC3
sbit X2 at RC4_bit;                    //битовая переменная X2 на линии порта RC4
sbit X3 at RC5_bit;                                  //битовая переменная X3 на линии порта RC5
sbit X4 at RC6_bit;                                 //битовая переменная X4 на линии порта RC6
sbit X5 at RC7_bit;                                   //битовая переменная X5 на линии порта RC7
sbit Y1 at RE0_bit;                            //битовая переменная Y1 на линии порта RE0
sbit Y2 at RE1_bit;                               //битовая переменная Y2 на линии порта RE1
sbit Y3 at RE2_bit;                                       //битовая переменная Y3 на линии порта RE2

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



void interrupt()                //функция-обработчик прерываний от TMR0 и INT
{


    if( INTF == 1 )                                                     //если запрос прерывания по INT
    {

        flag1 = 1;

        PORTB.B1 = 1;                       // включить светодиод
        Delay_ms(50);                    // задержка на 500 мс
        PORTB.B1 = 0;                       // выключить светодиод
        Delay_ms(50);
        INTCON = 0;

    }
    //INTF_bit = 0;



    counter++;
    if(counter == 100)                                                          //если прошло время опроса 1,8 с
    {
        flag_T = 1;                                                //установить флаг окончания отсчета
        //времени       Топр = 0.75 с
        counter = 0;
    }
    TMR0 = 44;                                                                   //перезагрузить таймер
    T0IF_bit = 0;                                                         //сбросить флаг запроса прерывания T0IF



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

        Lcd_Cmd(_LCD_CLEAR);          // очистить ЖКД
        Lcd_Out(1, 5, "ERROR");           // вывод на дисплей
        // сообщения об аварии
        Sound_Play(500,10000);          // вывод звукового сигнала
        // частоты 500 Гц длительностью 10 секунд
        while (1)              // вывод мигающего светового сигнала  и
        {                                                     // зацикливание программы
            PORTB.B1 = 1;                       // включить светодиод
            Delay_ms(5);                    // задержка на 500 мс
            PORTB.B1 = 0;                       // выключить светодиод
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




        //        PORTB.B1 = 1;                       // включить светодиод
        //        Delay_ms(1);                    // задержка на 500 мс
        //        PORTB.B1 = 0;                       // выключить светодиод
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

    bit f;                                        //битовая переменная для хранения результата
    //вычисления логической функции

    f = (!( (!X1) && (!X5) && (!X3) )) || (!X2) || (!X4);         //логическая функция

    if ( f == 1 )                                      //если результат равен 1
    {
        Y1=1;
        Delay_us(70);
        Y1=0;
    }

}



void analog()
{

    int g;                                                        //двухбайтные переменные для хранения
    int e;                                                        //результатов вычисления
    int h;                                                                //функций g(), e(), h()
    char DC1;                                                //переменная для рабочего цикла ШИМ

    //чтение кодов АЦП
    W1 = ADC_Read(0);                                //аналоговый канал 0 (сигнал U1)
    W2 = ADC_Read(1);                                //аналоговый канал 0 (сигнал U2)
    W3 = ADC_Read(2);                                 //аналоговый канал 0 (сигнал U3)
    W4 = ADC_Read(3);                                 //аналоговый канал 0 (сигнал U4)
    W5 = ADC_Read(4);                                 //аналоговый канал 0 (сигнал U5)

    g = 5*W1 + 2*K2 - ( 3*W3 + K1 ) / K3;   //вычисление функции g()


    if ( g >= Q )
    {
        Y3=1;                                              //вывод сигнала Y3
        Delay_ms(23);
        Y3=0;
    }
    else
    {
        Y2 = 1;
        Delay_ms(18);
        Y2 = 0;
    }


    h = W5 / K5;                              //вычисление функции h()  
    e = W4 / (2*K4);

    //    if ( flag_shim == 1 )

    DC1 = h;                                                          //определить величину рабочего цикла
    PWM1_Set_Duty(DC1);                                  //установить текущий рабочий цикл для //PWM2


                                               //вычисление функции e()

    //    if ( flag_shim == 0 )
    //    {
    DC1 = e;                                                        //определить величину рабочего цикла
    PWM2_Set_Duty(DC1);                        //установить текущий рабочий цикл для //PWM1
    //    }

}




void display()
{

    int mvolts;                          //переменная для хранения величины напряжения в
    //милливольтах
    char num;                                           //переменная для хранения цифр напряжения в
    //вольтах
    switch (key)
    {
    case 1:
    {
        mvolts = ((long)W1*5000) / 0x03FF;                     //преобразование
        //кода W1 в милливольты
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U1=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                         // вывод цифры в коде ASCII
        Lcd_Chr_Cp('.');                                      //вывод на ЖКД десятичной точки
        num = (mvolts / 100) % 10;                             //извлечение десятых долей вольта
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //в текущую позицию курсора
        break;
    }
    case 2:
    {
        mvolts = ((long)W2*5000) / 0x03FF;                             //преобразование кода W2 в милливольты
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U2=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                            // вывод цифры в коде ASCII
        Lcd_Chr_Cp('.');                                                  //вывод на ЖКД десятичной точки
        num = (mvolts / 100) % 10;                             //извлечение десятых долей вольта
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //в текущую позицию курсора
        break;
    }
    case 3:
    {
        mvolts = ((long)W3*5000) / 0x03FF;                             //преобразование кода W3 в милливольты
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U3=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                        // вывод цифры в коде ASCII
        Lcd_Chr_Cp('.');                                           //вывод на ЖКД десятичной точки
        num = (mvolts / 100) % 10;                      //извлечение десятых долей вольта
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //в текущую позицию курсора
        break;
    }
    case 5:
    {
        mvolts = ((long)W4*5000) / 0x03FF;                             //преобразование кода W4 в милливольты
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U4=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                          // вывод цифры в коде ASCII
        Lcd_Chr_Cp('.');                                                //вывод на ЖКД десятичной точки
        num = (mvolts / 100) % 10;                                     //извлечение десятых долей вольта
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //в текущую позицию курсора
        break;
    }
    case 6:
    {
        mvolts = ((long)W5*5000) / 0x03FF;                             //преобразование кода W5 в милливольты
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,4, "Work Mode");
        Lcd_Out(2,4, "U5=");
        num = mvolts / 1000;
        Lcd_Chr_Cp(48+num);                                        // вывод цифры в коде ASCII
        Lcd_Chr_Cp('.');                                                 //вывод на ЖКД десятичной точки
        num = (mvolts / 100) % 10;                                   //извлечение десятых долей вольта
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Chr_Cp(48+num);
        num = (mvolts / 10) % 10;
        Lcd_Out_Cp("V");                                                //в текущую позицию курсора
        break;
    }

    case 7:
    {


        flag_T = 1;
        flag_shim = (!flag_shim);
        PORTB.B1 = 1;                       // включить светодиод
        Delay_ms(1);                    // задержка на 500 мс
        PORTB.B1 = 0;                       // выключить светодиод
        Delay_ms(1);


    }




    }

}
