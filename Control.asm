
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Control.c,62 :: 		void interrupt()                //функция-обработчик прерываний от TMR0 и INT
;Control.c,69 :: 		flag1 = 1;
	MOVLW      1
	MOVWF      _flag1+0
;Control.c,71 :: 		PORTB.B1 = 1;                       // включить светодиод
	BSF        PORTB+0, 1
;Control.c,72 :: 		Delay_ms(50);                    // задержка на 500 мс
	MOVLW      236
	MOVWF      R12+0
	MOVLW      98
	MOVWF      R13+0
L_interrupt1:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt1
	DECFSZ     R12+0, 1
	GOTO       L_interrupt1
	NOP
;Control.c,73 :: 		PORTB.B1 = 0;                       // выключить светодиод
	BCF        PORTB+0, 1
;Control.c,74 :: 		Delay_ms(50);
	MOVLW      236
	MOVWF      R12+0
	MOVLW      98
	MOVWF      R13+0
L_interrupt2:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt2
	DECFSZ     R12+0, 1
	GOTO       L_interrupt2
	NOP
;Control.c,75 :: 		INTCON = 0;
	CLRF       INTCON+0
;Control.c,82 :: 		counter++;
	INCF       _counter+0, 1
;Control.c,83 :: 		if(counter == 100)                                                          //если прошло время опроса 1,8 с
	MOVF       _counter+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;Control.c,85 :: 		flag_T = 1;                                                //установить флаг окончания отсчета
	MOVLW      1
	MOVWF      _flag_T+0
;Control.c,87 :: 		counter = 0;
	CLRF       _counter+0
;Control.c,88 :: 		}
L_interrupt3:
;Control.c,89 :: 		TMR0 = 44;                                                                   //перезагрузить таймер
	MOVLW      44
	MOVWF      TMR0+0
;Control.c,90 :: 		T0IF_bit = 0;                                                         //сбросить флаг запроса прерывания T0IF
	BCF        T0IF_bit+0, 2
;Control.c,94 :: 		}
L__interrupt32:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Control.c,100 :: 		void main ()
;Control.c,103 :: 		init();
	CALL       _init+0
;Control.c,107 :: 		again:
___main_again:
;Control.c,108 :: 		digit();
	CALL       _digit+0
;Control.c,109 :: 		analog();
	CALL       _analog+0
;Control.c,110 :: 		opros:
___main_opros:
;Control.c,112 :: 		if ( flag1 == 1 )
	MOVF       _flag1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;Control.c,115 :: 		Lcd_Cmd(_LCD_CLEAR);          // очистить ЖКД
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,116 :: 		Lcd_Out(1, 5, "ERROR");           // вывод на дисплей
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,118 :: 		Sound_Play(500,10000);          // вывод звукового сигнала
	MOVLW      244
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      1
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      16
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      39
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Control.c,120 :: 		while (1)              // вывод мигающего светового сигнала  и
L_main5:
;Control.c,122 :: 		PORTB.B1 = 1;                       // включить светодиод
	BSF        PORTB+0, 1
;Control.c,123 :: 		Delay_ms(5);                    // задержка на 500 мс
	MOVLW      24
	MOVWF      R12+0
	MOVLW      136
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	NOP
	NOP
;Control.c,124 :: 		PORTB.B1 = 0;                       // выключить светодиод
	BCF        PORTB+0, 1
;Control.c,125 :: 		Delay_ms(5);
	MOVLW      24
	MOVWF      R12+0
	MOVLW      136
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	NOP
	NOP
;Control.c,126 :: 		}
	GOTO       L_main5
;Control.c,129 :: 		}
L_main4:
;Control.c,132 :: 		key = 0;
	CLRF       _key+0
;Control.c,133 :: 		key = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _key+0
;Control.c,135 :: 		if (key !=0)
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
;Control.c,137 :: 		display();
	CALL       _display+0
;Control.c,139 :: 		}
L_main9:
;Control.c,141 :: 		if (flag_T == 0)
	MOVF       _flag_T+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;Control.c,142 :: 		goto opros
	GOTO       ___main_opros
L_main10:
;Control.c,145 :: 		flag_T = 0;
	CLRF       _flag_T+0
;Control.c,146 :: 		counter = 0;
	CLRF       _counter+0
;Control.c,147 :: 		TMR0 = 44;
	MOVLW      44
	MOVWF      TMR0+0
;Control.c,156 :: 		goto again;
	GOTO       ___main_again
;Control.c,158 :: 		}
	GOTO       $+0
; end of _main

_init:

;Control.c,173 :: 		void init()
;Control.c,176 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;Control.c,177 :: 		TRISB = 0b11111101;
	MOVLW      253
	MOVWF      TRISB+0
;Control.c,178 :: 		TRISC = 0b11111000;
	MOVLW      248
	MOVWF      TRISC+0
;Control.c,179 :: 		TRISE = 0;
	CLRF       TRISE+0
;Control.c,180 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;Control.c,181 :: 		PORTE = 0;
	CLRF       PORTE+0
;Control.c,182 :: 		PORTB.B1 = 0;
	BCF        PORTB+0, 1
;Control.c,183 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Control.c,184 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,185 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,186 :: 		Lcd_Out(1,4, "Work Mode");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,187 :: 		ADC_Init();
	CALL       _ADC_Init+0
;Control.c,188 :: 		Keypad_Init();
	CALL       _Keypad_Init+0
;Control.c,190 :: 		PWM1_Init(40000);
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      89
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Control.c,191 :: 		PWM2_Init(40000);
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      89
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;Control.c,193 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;Control.c,194 :: 		PWM2_Start();
	CALL       _PWM2_Start+0
;Control.c,197 :: 		Sound_Init(&PORTC,0);
	MOVLW      PORTC+0
	MOVWF      FARG_Sound_Init_snd_port+0
	CLRF       FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;Control.c,198 :: 		OPTION_REG = 0b00101010;
	MOVLW      42
	MOVWF      OPTION_REG+0
;Control.c,199 :: 		TMR0 = 44;
	MOVLW      44
	MOVWF      TMR0+0
;Control.c,200 :: 		INTCON = 0xB0;
	MOVLW      176
	MOVWF      INTCON+0
;Control.c,201 :: 		flag1 = 0;
	CLRF       _flag1+0
;Control.c,203 :: 		}
	RETURN
; end of _init

_digit:

;Control.c,207 :: 		void digit()
;Control.c,213 :: 		f = (!( (!X1) && (!X5) && (!X3) )) || (!X2) || (!X4);         //логическая функция
	BTFSC      RC3_bit+0, 3
	GOTO       L_digit13
	BTFSC      RC7_bit+0, 7
	GOTO       L_digit13
	BTFSC      RC5_bit+0, 5
	GOTO       L_digit13
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_digit12
L_digit13:
	CLRF       R0+0
L_digit12:
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_digit15
	BTFSS      RC4_bit+0, 4
	GOTO       L_digit15
	BTFSS      RC6_bit+0, 6
	GOTO       L_digit15
	CLRF       R0+0
	GOTO       L_digit14
L_digit15:
	MOVLW      1
	MOVWF      R0+0
L_digit14:
	BTFSC      R0+0, 0
	GOTO       L__digit33
	BCF        digit_f_L0+0, BitPos(digit_f_L0+0)
	GOTO       L__digit34
L__digit33:
	BSF        digit_f_L0+0, BitPos(digit_f_L0+0)
L__digit34:
;Control.c,215 :: 		if ( f == 1 )                                      //если результат равен 1
	BTFSS      digit_f_L0+0, BitPos(digit_f_L0+0)
	GOTO       L_digit16
;Control.c,217 :: 		Y1=1;
	BSF        RE0_bit+0, 0
;Control.c,218 :: 		Delay_us(70);
	MOVLW      84
	MOVWF      R13+0
L_digit17:
	DECFSZ     R13+0, 1
	GOTO       L_digit17
	NOP
;Control.c,219 :: 		Y1=0;
	BCF        RE0_bit+0, 0
;Control.c,220 :: 		}
L_digit16:
;Control.c,222 :: 		}
	RETURN
; end of _digit

_analog:

;Control.c,226 :: 		void analog()
;Control.c,235 :: 		W1 = ADC_Read(0);                                //аналоговый канал 0 (сигнал U1)
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _W1+0
	MOVF       R0+1, 0
	MOVWF      _W1+1
;Control.c,236 :: 		W2 = ADC_Read(1);                                //аналоговый канал 0 (сигнал U2)
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _W2+0
	MOVF       R0+1, 0
	MOVWF      _W2+1
;Control.c,237 :: 		W3 = ADC_Read(2);                                 //аналоговый канал 0 (сигнал U3)
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _W3+0
	MOVF       R0+1, 0
	MOVWF      _W3+1
;Control.c,238 :: 		W4 = ADC_Read(3);                                 //аналоговый канал 0 (сигнал U4)
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _W4+0
	MOVF       R0+1, 0
	MOVWF      _W4+1
;Control.c,239 :: 		W5 = ADC_Read(4);                                 //аналоговый канал 0 (сигнал U5)
	MOVLW      4
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _W5+0
	MOVF       R0+1, 0
	MOVWF      _W5+1
;Control.c,241 :: 		g = 5*W1 + 2*K2 - ( 3*W3 + K1 ) / K3;   //вычисление функции g()
	MOVF       _W1+0, 0
	MOVWF      R0+0
	MOVF       _W1+1, 0
	MOVWF      R0+1
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      16
	ADDWF      R0+0, 0
	MOVWF      FLOC__analog+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      FLOC__analog+1
	MOVF       _W3+0, 0
	MOVWF      R0+0
	MOVF       _W3+1, 0
	MOVWF      R0+1
	MOVLW      3
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      20
	ADDWF      R0+0, 1
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 1
	MOVLW      15
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	SUBWF      FLOC__analog+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      FLOC__analog+1, 0
	MOVWF      R2+1
;Control.c,244 :: 		if ( g >= Q )
	MOVLW      128
	XORWF      R2+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__analog35
	MOVLW      55
	SUBWF      R2+0, 0
L__analog35:
	BTFSS      STATUS+0, 0
	GOTO       L_analog18
;Control.c,246 :: 		Y3=1;                                              //вывод сигнала Y3
	BSF        RE2_bit+0, 2
;Control.c,247 :: 		Delay_ms(23);
	MOVLW      109
	MOVWF      R12+0
	MOVLW      70
	MOVWF      R13+0
L_analog19:
	DECFSZ     R13+0, 1
	GOTO       L_analog19
	DECFSZ     R12+0, 1
	GOTO       L_analog19
;Control.c,248 :: 		Y3=0;
	BCF        RE2_bit+0, 2
;Control.c,249 :: 		}
	GOTO       L_analog20
L_analog18:
;Control.c,252 :: 		Y2 = 1;
	BSF        RE1_bit+0, 1
;Control.c,253 :: 		Delay_ms(18);
	MOVLW      85
	MOVWF      R12+0
	MOVLW      188
	MOVWF      R13+0
L_analog21:
	DECFSZ     R13+0, 1
	GOTO       L_analog21
	DECFSZ     R12+0, 1
	GOTO       L_analog21
	NOP
;Control.c,254 :: 		Y2 = 0;
	BCF        RE1_bit+0, 1
;Control.c,255 :: 		}
L_analog20:
;Control.c,258 :: 		h = W5 / K5;                              //вычисление функции h()
	MOVLW      12
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _W5+0, 0
	MOVWF      R0+0
	MOVF       _W5+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      analog_h_L0+0
	MOVF       R0+1, 0
	MOVWF      analog_h_L0+1
;Control.c,259 :: 		e = W4 / (2*K4);
	MOVLW      80
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _W4+0, 0
	MOVWF      R0+0
	MOVF       _W4+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      analog_e_L0+0
	MOVF       R0+1, 0
	MOVWF      analog_e_L0+1
;Control.c,264 :: 		PWM1_Set_Duty(DC1);                                  //установить текущий рабочий цикл для //PWM2
	MOVF       analog_h_L0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Control.c,272 :: 		PWM2_Set_Duty(DC1);                        //установить текущий рабочий цикл для //PWM1
	MOVF       analog_e_L0+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Control.c,275 :: 		}
	RETURN
; end of _analog

_display:

;Control.c,280 :: 		void display()
;Control.c,287 :: 		switch (key)
	GOTO       L_display22
;Control.c,289 :: 		case 1:
L_display24:
;Control.c,291 :: 		mvolts = ((long)W1*5000) / 0x03FF;                     //преобразование
	MOVF       _W1+0, 0
	MOVWF      R0+0
	MOVF       _W1+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      display_mvolts_L0+0
	MOVF       R0+1, 0
	MOVWF      display_mvolts_L0+1
;Control.c,293 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,294 :: 		Lcd_Out(1,4, "Work Mode");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,295 :: 		Lcd_Out(2,4, "U1=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,296 :: 		num = mvolts / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
;Control.c,297 :: 		Lcd_Chr_Cp(48+num);                                         // вывод цифры в коде ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,298 :: 		Lcd_Chr_Cp('.');                                      //вывод на ЖКД десятичной точки
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,299 :: 		num = (mvolts / 100) % 10;                             //извлечение десятых долей вольта
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,300 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,301 :: 		num = (mvolts / 10) % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,302 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,304 :: 		Lcd_Out_Cp("V");                                                //в текущую позицию курсора
	MOVLW      ?lstr5_Control+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;Control.c,305 :: 		break;
	GOTO       L_display23
;Control.c,307 :: 		case 2:
L_display25:
;Control.c,309 :: 		mvolts = ((long)W2*5000) / 0x03FF;                             //преобразование кода W2 в милливольты
	MOVF       _W2+0, 0
	MOVWF      R0+0
	MOVF       _W2+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      display_mvolts_L0+0
	MOVF       R0+1, 0
	MOVWF      display_mvolts_L0+1
;Control.c,310 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,311 :: 		Lcd_Out(1,4, "Work Mode");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,312 :: 		Lcd_Out(2,4, "U2=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,313 :: 		num = mvolts / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
;Control.c,314 :: 		Lcd_Chr_Cp(48+num);                                            // вывод цифры в коде ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,315 :: 		Lcd_Chr_Cp('.');                                                  //вывод на ЖКД десятичной точки
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,316 :: 		num = (mvolts / 100) % 10;                             //извлечение десятых долей вольта
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,317 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,318 :: 		num = (mvolts / 10) % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,319 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,321 :: 		Lcd_Out_Cp("V");                                                //в текущую позицию курсора
	MOVLW      ?lstr8_Control+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;Control.c,322 :: 		break;
	GOTO       L_display23
;Control.c,324 :: 		case 3:
L_display26:
;Control.c,326 :: 		mvolts = ((long)W3*5000) / 0x03FF;                             //преобразование кода W3 в милливольты
	MOVF       _W3+0, 0
	MOVWF      R0+0
	MOVF       _W3+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      display_mvolts_L0+0
	MOVF       R0+1, 0
	MOVWF      display_mvolts_L0+1
;Control.c,327 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,328 :: 		Lcd_Out(1,4, "Work Mode");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,329 :: 		Lcd_Out(2,4, "U3=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,330 :: 		num = mvolts / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
;Control.c,331 :: 		Lcd_Chr_Cp(48+num);                                        // вывод цифры в коде ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,332 :: 		Lcd_Chr_Cp('.');                                           //вывод на ЖКД десятичной точки
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,333 :: 		num = (mvolts / 100) % 10;                      //извлечение десятых долей вольта
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,334 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,335 :: 		num = (mvolts / 10) % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,336 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,338 :: 		Lcd_Out_Cp("V");                                                //в текущую позицию курсора
	MOVLW      ?lstr11_Control+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;Control.c,339 :: 		break;
	GOTO       L_display23
;Control.c,341 :: 		case 5:
L_display27:
;Control.c,343 :: 		mvolts = ((long)W4*5000) / 0x03FF;                             //преобразование кода W4 в милливольты
	MOVF       _W4+0, 0
	MOVWF      R0+0
	MOVF       _W4+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      display_mvolts_L0+0
	MOVF       R0+1, 0
	MOVWF      display_mvolts_L0+1
;Control.c,344 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,345 :: 		Lcd_Out(1,4, "Work Mode");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,346 :: 		Lcd_Out(2,4, "U4=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,347 :: 		num = mvolts / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
;Control.c,348 :: 		Lcd_Chr_Cp(48+num);                                          // вывод цифры в коде ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,349 :: 		Lcd_Chr_Cp('.');                                                //вывод на ЖКД десятичной точки
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,350 :: 		num = (mvolts / 100) % 10;                                     //извлечение десятых долей вольта
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,351 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,352 :: 		num = (mvolts / 10) % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,353 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,355 :: 		Lcd_Out_Cp("V");                                                //в текущую позицию курсора
	MOVLW      ?lstr14_Control+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;Control.c,356 :: 		break;
	GOTO       L_display23
;Control.c,358 :: 		case 6:
L_display28:
;Control.c,360 :: 		mvolts = ((long)W5*5000) / 0x03FF;                             //преобразование кода W5 в милливольты
	MOVF       _W5+0, 0
	MOVWF      R0+0
	MOVF       _W5+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_S+0
	MOVF       R0+0, 0
	MOVWF      display_mvolts_L0+0
	MOVF       R0+1, 0
	MOVWF      display_mvolts_L0+1
;Control.c,361 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Control.c,362 :: 		Lcd_Out(1,4, "Work Mode");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,363 :: 		Lcd_Out(2,4, "U5=");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr16_Control+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Control.c,364 :: 		num = mvolts / 1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
;Control.c,365 :: 		Lcd_Chr_Cp(48+num);                                        // вывод цифры в коде ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,366 :: 		Lcd_Chr_Cp('.');                                                 //вывод на ЖКД десятичной точки
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,367 :: 		num = (mvolts / 100) % 10;                                   //извлечение десятых долей вольта
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,368 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,369 :: 		num = (mvolts / 10) % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       display_mvolts_L0+0, 0
	MOVWF      R0+0
	MOVF       display_mvolts_L0+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
;Control.c,370 :: 		Lcd_Chr_Cp(48+num);
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;Control.c,372 :: 		Lcd_Out_Cp("V");                                                //в текущую позицию курсора
	MOVLW      ?lstr17_Control+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;Control.c,373 :: 		break;
	GOTO       L_display23
;Control.c,376 :: 		case 7:
L_display29:
;Control.c,380 :: 		flag_T = 1;
	MOVLW      1
	MOVWF      _flag_T+0
;Control.c,381 :: 		flag_shim = (!flag_shim);
	MOVF       _flag_shim+0, 0
	IORWF      _flag_shim+1, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _flag_shim+0
	MOVWF      _flag_shim+1
	MOVLW      0
	MOVWF      _flag_shim+1
;Control.c,382 :: 		PORTB.B1 = 1;                       // включить светодиод
	BSF        PORTB+0, 1
;Control.c,383 :: 		Delay_ms(1);                    // задержка на 500 мс
	MOVLW      5
	MOVWF      R12+0
	MOVLW      180
	MOVWF      R13+0
L_display30:
	DECFSZ     R13+0, 1
	GOTO       L_display30
	DECFSZ     R12+0, 1
	GOTO       L_display30
;Control.c,384 :: 		PORTB.B1 = 0;                       // выключить светодиод
	BCF        PORTB+0, 1
;Control.c,385 :: 		Delay_ms(1);
	MOVLW      5
	MOVWF      R12+0
	MOVLW      180
	MOVWF      R13+0
L_display31:
	DECFSZ     R13+0, 1
	GOTO       L_display31
	DECFSZ     R12+0, 1
	GOTO       L_display31
;Control.c,393 :: 		}
	GOTO       L_display23
L_display22:
	MOVF       _key+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_display24
	MOVF       _key+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_display25
	MOVF       _key+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_display26
	MOVF       _key+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_display27
	MOVF       _key+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_display28
	MOVF       _key+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_display29
L_display23:
;Control.c,395 :: 		}
	RETURN
; end of _display
