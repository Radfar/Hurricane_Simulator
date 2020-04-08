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

#include <mega32.h>
#include "delay.h"
#define left   0x01
#define right  0x02 
#define To_LCD    PORTA
#define RS      PORTB.0
#define RW      PORTB.1
#define En      PORTB.2
#define BL      PORTB.3
#define UP      PIND.0
#define OK      PIND.1
#define DN      PIND.2

/******************************/
#define Clear_LCD 			0x01
#define Return_Home 			0x02
#define Shift_Cursor_Left		0x04
#define Shift_Cursor_Right		0x06
#define Shift_Display_Left		0x05
#define Shift_Display_Right		0x07
#define DisplayOff_CursorOff		0x08
#define DisplayOff_CursorOn 		0x0a
#define DisplayOn_CursorOff    		0x0c
#define DisplayOn_CursorOn		0x0e
#define DisplayOn_CursorBlinking	0x0f
#define Use_Matrix			0x38


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
RS=0;RW=0;En=1;
delay_ms(2);
RS=0;RW=0;En=0;
delay_ms(2);
}
/******************************/
void LCD_Data (void)
{
RS=1;RW=0;En=1;
delay_ms(2);
RS=1;RW=0;En=0;
delay_ms(2);
}
/********************************/   
void PassOK()
{
To_LCD=Clear_LCD;        
LCD_Cmnd();
To_LCD='P';LCD_Data();
To_LCD='A';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD=' ';LCD_Data();
To_LCD='O';LCD_Data();
To_LCD='K';LCD_Data(); 
}
/********************************/   
void ErrorPass()
{
To_LCD=Clear_LCD;
LCD_Cmnd();
To_LCD='E';LCD_Data();
To_LCD='R';LCD_Data();
To_LCD='R';LCD_Data();
To_LCD='O';LCD_Data();
To_LCD='R';LCD_Data();
To_LCD=' ';LCD_Data();
To_LCD='P';LCD_Data();
To_LCD='A';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD='S';LCD_Data();
}
/********************************/   
void EnterPass()
{
To_LCD=Clear_LCD;
LCD_Cmnd();
To_LCD='E';LCD_Data();
To_LCD='N';LCD_Data();
To_LCD='T';LCD_Data();
To_LCD='E';LCD_Data();
To_LCD='R';LCD_Data();
To_LCD=' ';LCD_Data();
To_LCD='P';LCD_Data();
To_LCD='A';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD=':';LCD_Data();
To_LCD=DisplayOn_CursorOff;
LCD_Cmnd();
menu=0;
}                             
/***************************************/
void POS_En()
{
To_LCD=Clear_LCD;
LCD_Cmnd();
To_LCD='P';LCD_Data();
To_LCD='O';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD=':';LCD_Data();
To_LCD=' ';LCD_Data();
To_LCD='E';LCD_Data();
To_LCD='n';LCD_Data();
To_LCD='a';LCD_Data();
To_LCD='b';LCD_Data();
To_LCD='l';LCD_Data();
To_LCD='e';LCD_Data();
pos=1;
}
/***************************************/
void POS_Dis()
{
To_LCD=Clear_LCD;
LCD_Cmnd();
To_LCD='P';LCD_Data();
To_LCD='O';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD=':';LCD_Data();
To_LCD=' ';LCD_Data();
To_LCD='D';LCD_Data();
To_LCD='i';LCD_Data();
To_LCD='s';LCD_Data();
To_LCD='a';LCD_Data();
To_LCD='b';LCD_Data();
To_LCD='l';LCD_Data();
To_LCD='e';LCD_Data();
pos=0;
}
/*******************************/
void Init()
{
PORTA=0x00;DDRA=0xFF;PORTB=0x00;DDRB=0xff;PORTC=0x00;DDRC=0xFF;PORTD=0x00;DDRD=0x00;
TCCR0=0x00;TCNT0=0x00;OCR0=0x00;TCCR1A=0x00;TCCR1B=0x00;TCNT1H=0x00;TCNT1L=0x00;ICR1H=0x00;
ICR1L=0x00;OCR1AH=0x00;OCR1AL=0x00;OCR1BH=0x00;OCR1BL=0x00;ASSR=0x00;TCCR2=0x00;TCNT2=0x00;OCR2=0x00;
MCUCR=0x00;MCUCSR=0x00;TIMSK=0x00;ACSR=0x80;SFIOR=0x00;
To_LCD=Use_Matrix;LCD_Cmnd();
To_LCD=Return_Home;LCD_Cmnd();
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
        if(DN)         
                {
                delay_ms(150);
                while(DN); 
                if(cnt>0x30)
                        cnt--;
                To_LCD=Clear_LCD;
                LCD_Cmnd();
                To_LCD=cnt;
                LCD_Data();
                }
        if(UP)
                {
                delay_ms(150);
                while(UP);
                if(cnt<0x39)
                        cnt++;
                To_LCD=Clear_LCD;
                LCD_Cmnd();
                To_LCD=cnt;
                LCD_Data();
                }
        if(OK)
                {
                i++;            
                delay_ms(150);
                while(OK);
                Pass[i-1]=cnt;
                cnt=0x30;
                To_LCD=Clear_LCD;
                LCD_Cmnd();
                for(j=0;j<i;j++)
                        {
                        To_LCD='*';
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
                if(DN)         
                        {
                        delay_ms(150);
                        while(DN); 
                        POS_Dis();
                        }
                if(UP)
                        {
                        delay_ms(150);
                        while(UP);
                        To_LCD=Clear_LCD;
                        LCD_Cmnd();
                        POS_En();        
                        }
                }while(!OK);
        if(OK)
                {
                delay_ms(150);
                while(OK);
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
