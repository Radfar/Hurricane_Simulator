/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.8 Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2016/01/26
Author  : Radfar                          
Company : MTAG                            
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega32
#pragma used+
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADCSR=6;     // for compatibility with older code
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
/******************************/
// Declare your global variables here
char SVNSG[10]={0x7e,0x30,0xed,0xf9,0x33,0xdb,0xdf,0xf0,0xff,0xfb}; 
char Sel[8]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};  
char Pass[4]={0,0,0,0}; 
char menu=0,amount=1,time=3;     
bit pos=1;
//flash char PASSOK[4]={1,2,4,8};  
/******************************/
void LCD_Cmnd (void)
{
PORTB.0=0;PORTB.1=0;PORTB.2=1;
delay_ms(2);
PORTB.0=0;PORTB.1=0;PORTB.2=0;
delay_ms(2);
}
/******************************/
void LCD_Data (void)
{
PORTB.0=1;PORTB.1=0;PORTB.2=1;
delay_ms(2);
PORTB.0=1;PORTB.1=0;PORTB.2=0;
delay_ms(2);
}
/********************************/   
void PassOK()
{
PORTA=0x01;        
LCD_Cmnd();
PORTA='P';LCD_Data();
PORTA='A';LCD_Data();
PORTA='S';LCD_Data();
PORTA='S';LCD_Data();
PORTA=' ';LCD_Data();
PORTA='O';LCD_Data();
PORTA='K';LCD_Data(); 
}
/********************************/   
void ErrorPass()
{
PORTA=0x01;
LCD_Cmnd();
PORTA='E';LCD_Data();
PORTA='R';LCD_Data();
PORTA='R';LCD_Data();
PORTA='O';LCD_Data();
PORTA='R';LCD_Data();
PORTA=' ';LCD_Data();
PORTA='P';LCD_Data();
PORTA='A';LCD_Data();
PORTA='S';LCD_Data();
PORTA='S';LCD_Data();
}
/********************************/   
void EnterPass()
{
PORTA=0x01;
LCD_Cmnd();
PORTA='E';LCD_Data();
PORTA='N';LCD_Data();
PORTA='T';LCD_Data();
PORTA='E';LCD_Data();
PORTA='R';LCD_Data();
PORTA=' ';LCD_Data();
PORTA='P';LCD_Data();
PORTA='A';LCD_Data();
PORTA='S';LCD_Data();
PORTA='S';LCD_Data();
PORTA=':';LCD_Data();
PORTA=0x0c;
LCD_Cmnd();
menu=0;
}                             
/***************************************/
void POS_En()
{
PORTA=0x01;
LCD_Cmnd();
PORTA='P';LCD_Data();
PORTA='O';LCD_Data();
PORTA='S';LCD_Data();
PORTA=':';LCD_Data();
PORTA=' ';LCD_Data();
PORTA='E';LCD_Data();
PORTA='n';LCD_Data();
PORTA='a';LCD_Data();
PORTA='b';LCD_Data();
PORTA='l';LCD_Data();
PORTA='e';LCD_Data();
pos=1;
}
/***************************************/
void POS_Dis()
{
PORTA=0x01;
LCD_Cmnd();
PORTA='P';LCD_Data();
PORTA='O';LCD_Data();
PORTA='S';LCD_Data();
PORTA=':';LCD_Data();
PORTA=' ';LCD_Data();
PORTA='D';LCD_Data();
PORTA='i';LCD_Data();
PORTA='s';LCD_Data();
PORTA='a';LCD_Data();
PORTA='b';LCD_Data();
PORTA='l';LCD_Data();
PORTA='e';LCD_Data();
pos=0;
}
/*******************************/
void Init()
{
PORTA=0x00;DDRA=0xFF;PORTB=0x00;DDRB=0xff;PORTC=0x00;DDRC=0xFF;PORTD=0x00;DDRD=0x00;
TCCR0=0x00;TCNT0=0x00;OCR0=0x00;TCCR1A=0x00;TCCR1B=0x00;TCNT1H=0x00;TCNT1L=0x00;ICR1H=0x00;
ICR1L=0x00;OCR1AH=0x00;OCR1AL=0x00;OCR1BH=0x00;OCR1BL=0x00;ASSR=0x00;TCCR2=0x00;TCNT2=0x00;OCR2=0x00;
MCUCR=0x00;MCUCSR=0x00;TIMSK=0x00;ACSR=0x80;SFIOR=0x00;
PORTA=0x38;LCD_Cmnd();
PORTA=0x02;LCD_Cmnd();
menu=0;    //0:password   1:Amount  2:Time Duration  3.POS enabled
pos=1;     //pos=0: pos disable     pos=1: pos enable
amount=1;  //0:1000t   1:2000t  2:5000t   3:10000t  4.20000t
time=3;    //0:30sec  1:45sec   2:60sec   3:90sec 
}
/*************************************************/
void main(void)
{ 
unsigned int cnt=0;
char i=0,j=0;                     
Init();
cnt=0x30;i=0;                              
EnterPass();
while(1)
{
while(menu == 0)
        {
        if(PIND.2)         
                {
                delay_ms(150);
                while(PIND.2); 
                if(cnt>0x30)
                        cnt--;
                PORTA=0x01;
                LCD_Cmnd();
                PORTA=cnt;
                LCD_Data();
                }
        if(PIND.0)
                {
                delay_ms(150);
                while(PIND.0);
                if(cnt<0x39)
                        cnt++;
                PORTA=0x01;
                LCD_Cmnd();
                PORTA=cnt;
                LCD_Data();
                }
        if(PIND.1)
                {
                i++;            
                delay_ms(150);
                while(PIND.1);
                Pass[i-1]=cnt;
                cnt=0x30;
                PORTA=0x01;
                LCD_Cmnd();
                for(j=0;j<i;j++)
                        {
                        PORTA='*';
                        LCD_Data();
                        }
                if(i==4)
                        {
                        if(Pass[0]==0x31 && Pass[1]==0x32 && Pass[2]==0x31 && Pass[3]==0x33) //pass:1213
                                {
                                PassOK();
                                //delay_ms(2000);
                                menu=5;
                                }
                        else
                                { 
                                ErrorPass();
                                i=0;
                                cnt=0x30;
                                delay_ms(3000);
                                EnterPass();
                                }  
                        }//if(i==4)
                }//if(OK)
        }//while(menu==0)
while(menu == 1) //Amount Menu
        {
                }
while(menu == 2) //Time Menu
while(menu == 3) //POS ability menu
        {
        POS_En();
        do      {
                if(PIND.2)         
                        {
                        delay_ms(150);
                        while(PIND.2); 
                        POS_Dis();
                        }
                if(PIND.0)
                        {
                        delay_ms(150);
                        while(PIND.0);
                        PORTA=0x01;
                        LCD_Cmnd();
                        POS_En();        
                        }
                }while(!PIND.1);
        if(PIND.1)
                {
                delay_ms(150);
                while(PIND.1);
                menu=5;  //exit from menu
                break;
                }
         }
}
//while(1)
//delay_ms(3000);
        //BL=0;
//       cnt++;
//       if(cnt==27)
//         {
//         cnt=0;
//         i++;
//         if(i==10)
//                 {
//                 j++;
//                 i=0;
//                 if(j==10)
//                         j=0;
//                 }
//         } 
//       //for(i=0;i<10;i++)
//       //{   
//       PORTD=left;
//       PORTC=SVNSG[j];   
//       delay_ms(5); 
//       PORTD=right;
//       PORTC=SVNSG[i];
//       delay_ms(5);
      //}
//       for(i=0;i<2;i++)
//         {
//         PORTA=~Sel[i];
//         delay_us(100);
//         PORTB=SVNSG[i];
//         PORTD=SVNSG[i+1];
//         delay_us(1900);
//         }
      //};
}
