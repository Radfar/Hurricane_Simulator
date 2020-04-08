/*****************************************************
This program was published for send buy command to POS terminal and receive message
check sum OK Invoice Number omitted,(IDMess), invoice number greater than 9 do not work right, 
counter work well, lcd OK, menu ok,lighting ok, cabine light ok, start key light ok, 
http://www.atoaco.com
Project :Hurricane Simulator
Version : 4.4
Date    : 02/14/2016
Author  : Alireza Radfar
Company : AtoA
Comments: Ingenico 5100
Chip type           : ATmega64
Program type        : Application
Clock frequency     : 11.0592 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 1024
*****************************************************/
#include "mega64.h"  
#include "stdio.h"
#include "delay.h"

#define SVNSG_PORT               PORTC
#define To_LCD                   PORTB
#define Cabine_Light_On          PORTF &=0xfb //PORTF.2   1111 1011              // Cabine light
#define Cabine_Light_Off         PORTF |=0x04 //          0000 0100
#define Speaker_On               PORTF &=0xf7 //PORTF.3   1111 0111              // Speaker(MP3)
#define Speaker_Off              PORTF |=0x08 //          0000 1000
#define POS_Error_Light_On       PORTF &=0xbf //PORTF.6   1011 1111              // POS Error Light
#define POS_Error_Light_Off      PORTF |=0x40 //          0100 0000
#define Start_Key_Light          PORTA.0                                         // Start Key Light
#define Head_Light               PORTA.1                                         // X2 Head light
#define Relay6          PORTA.3
#define Motor                    PORTA.4                                         // Motor Drive
#define Relay8          PORTA.5
#define Lighting                 PORTA.6
#define MOS2                     PORTA.7 
#define RS485_Receive   PORTF &=0xfe //PORTF.1   1111 1101
#define RS485_Transmit  PORTF |=0x01 //          0000 0010
#define LCD_Buzz_Off    PORTF &=0xfe //PORTF.0   1111 1110
#define LCD_Buzz_On     PORTF |=0x01 //          0000 0001
#define LFTDIG_Off      PORTG &=0xfd //PORTG.1   1111 1101
#define LFTDIG_On       PORTG |=0x02 //          0000 0010
#define RGTDIG_Off      PORTG &=0xfe //PORTF.0   1111 1110
#define RGTDIG_On       PORTG |=0x01 //          0000 0001 
#define LCD_BL_0        PORTE &=0xef //PORTE.4   1110 1111  
#define LCD_BL_1        PORTE |=0x10 //          0001 0000
#define LCD_RS_0        PORTE &=0xdf //PORTE.5   1101 1111  
#define LCD_RS_1        PORTE |=0x20 //          0010 0000
#define LCD_RW_0        PORTE &=0xbf //PORTE.6   1011 1111
#define LCD_RW_1        PORTE |=0x40 //          0100 0000
#define LCD_EN_0        PORTE &=0x7f //PORTE.7   0111 1111
#define LCD_EN_1        PORTE |=0x80 //          1000 0000
#define OK_Key          PIND.0
#define UP              (inch=PINE&0x08) == 0x08 //PINE.3
#define DN              (inch=PINE&0x04) == 0x04 //PINE.2
#define Start_Key       PIND.1
#define Input1          PIND.4
#define OnOff_Key       PIND.5
#define Magnet_In       PIND.6 
#define Input2          (inch=PING&0x10) == 0x10 //PING.4 
#define Input3          (inch=PING&0x08) == 0x08 //PING.3   
#define PIR_220         (inch=PINF&0x20) == 0x20 //PINF.5   
#define DOOR_220        (inch=PINF&0x10) == 0x10 //PINF.4   
#define Display_Buzz    PORTD.7
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
#define Enable          0
#define Disable         1      
#define ON              1
#define OFF             0      
#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
flash char BuyCommand[7]={'$','P','C','B','U','Y',','}; //check sum 0x55
char       AmountRial[7]={'1','0','0','0',',','0','0'}; //check sum 0x01 , 6 byte
char       AmountCS=0x01;
//flash BYTE InvoiceNum[3]={',','0','0'}; //check sum 0x00
flash char DateTimeD[16]={',','2','0','1','6','0','1','0','1','1','0','1','4','1','0',','}; //check sum 0x00
char       MessageID[2]={'0','0'};//check sum 0x00
flash char EndOfCommand[6]={',','0',',','*',0x0d,0x0a};
char       CheckSumNum[2]={'6','d'};
char       RecMess[32];
// Declare your global variables here
char SVNSG[10]={0x7e,0x30,0xed,0xf9,0x33,0xdb,0xdf,0xf0,0xff,0xfb}; 
char Sel[8]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};  
char Pass[4]={0,0,0,0}; //pass number
char menu=0;
unsigned int TimeCnt=0,IDMess=0; 
char LFTDIG,RGTDIG;
unsigned char Timer1Sec=0;
bit count=0,hdone=0,menu_set=0;  
char amount,time,pos; //default  amount=1 time=3 pos=2
/********************************************************************************/
/*                    Get a character from the USART1 Receiver                  */
/********************************************************************************/
#pragma used+
char getchar1(void)
{
char status,data;
while (1)
      {
      while (((status=UCSR1A) & RX_COMPLETE)==0);
      data=UDR1;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      };
}
#pragma used-
/********************************************************************************/
/*               Write a character to the USART1 Transmitter                    */
/********************************************************************************/
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-
/********************************************************************************/
/*                     Time Duration Set                                        */
/********************************************************************************/
#pragma used+
unsigned char RData(void)
{
RS485_Receive;
return getchar();
}
#pragma used-
/********************************************************************************/
/*                   Write a character to the USART1 Transmitter                */
/********************************************************************************/
#pragma used+
void TData(unsigned char c)
{
RS485_Transmit;
putchar(c);
}
#pragma used-  
/********************************************************************************/
/*                                                             */
/********************************************************************************/
void LCD_Cmnd (void)
{
LCD_RS_0;LCD_BL_0;LCD_RW_0;LCD_EN_1;
delay_ms(2);
LCD_RS_0;LCD_BL_0;LCD_RW_0;LCD_EN_0;
delay_ms(2);
}
/********************************************************************************/
/*                                                            */
/********************************************************************************/
void LCD_Data (void)
{
LCD_RS_1;LCD_BL_1;LCD_RW_0;LCD_EN_1;
delay_ms(2);
LCD_RS_1;LCD_BL_1;LCD_RW_0;LCD_EN_0;
delay_ms(2);
}
/********************************************************************************/
/*                                                            */
/********************************************************************************/
void TimeMenu()
{
To_LCD=Clear_LCD;        
LCD_Cmnd();
To_LCD='T';LCD_Data();
To_LCD='i';LCD_Data();
To_LCD='m';LCD_Data();
To_LCD='e';LCD_Data();
To_LCD=':';LCD_Data(); 
}
/********************************************************************************/
/*                     Time Duration Set                                        */
/********************************************************************************/
#define To30Sec   1
#define To45Sec   2
#define To60Sec   3
#define To90Sec   4
void TimeSet( char a)
{
if(a == 1)
        {
        To_LCD='3';LCD_Data(); 
        To_LCD='0';LCD_Data(); 
        To_LCD='S';LCD_Data(); 
        To_LCD='e';LCD_Data(); 
        To_LCD='c';LCD_Data(); 
        time=1;
        }
if(a == 2)
        {
        To_LCD='4';LCD_Data(); 
        To_LCD='5';LCD_Data(); 
        To_LCD='S';LCD_Data(); 
        To_LCD='e';LCD_Data(); 
        To_LCD='c';LCD_Data(); 
        time=2;
        }
if(a == 3)
        {
        To_LCD='6';LCD_Data(); 
        To_LCD='0';LCD_Data(); 
        To_LCD='S';LCD_Data(); 
        To_LCD='e';LCD_Data(); 
        To_LCD='c';LCD_Data(); 
        time=3;
        }
if(a == 4)
        {
        To_LCD='9';LCD_Data(); 
        To_LCD='0';LCD_Data(); 
        To_LCD='S';LCD_Data(); 
        To_LCD='e';LCD_Data(); 
        To_LCD='c';LCD_Data(); 
        time=4;
        }
}
/********************************************************************************/
/*                                                           */
/********************************************************************************/
void AmountMenu()
{
To_LCD=Clear_LCD;        
LCD_Cmnd();
To_LCD='A';LCD_Data();
To_LCD='m';LCD_Data();
To_LCD='o';LCD_Data();
To_LCD='u';LCD_Data();
To_LCD='n';LCD_Data();
To_LCD='t';LCD_Data();
To_LCD=':';LCD_Data(); 
}
/********************************************************************************/
/*                     POS Amount in Rials                                      */
/********************************************************************************/
#define To1000T    1
#define To2000T    2
#define To5000T    3
#define To10000T   4
#define To20000T   5
void AmountSet(char a)
{
if( a == 1)
        {
        To_LCD='1';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=' ';LCD_Data();
        To_LCD='T';LCD_Data();
        amount=1;
        AmountRial[0]='1';
        AmountRial[1]='0';
        AmountRial[2]='0';
        AmountRial[3]='0';
        AmountRial[4]='0';
        AmountRial[5]=',';
        AmountCS=0x31; //check sum
        }
if( a == 2)
        {
        To_LCD='2';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=' ';LCD_Data();
        To_LCD='T';LCD_Data(); 
        amount=2;
        AmountRial[0]='2';
        AmountRial[1]='0';
        AmountRial[2]='0';
        AmountRial[3]='0';
        AmountRial[4]='0';
        AmountRial[5]=',';
        AmountCS=0x32; //check sum
        }
if( a == 3)
        {
        To_LCD='5';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=' ';LCD_Data();
        To_LCD='T';LCD_Data(); 
        amount=3;
        AmountRial[0]='5';
        AmountRial[1]='0';
        AmountRial[2]='0';
        AmountRial[3]='0';
        AmountRial[4]='0';
        AmountRial[5]=',';
        AmountCS=0x35; //check sum
        }
if( a == 4)
        {
        To_LCD='1';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=',';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=' ';LCD_Data();
        To_LCD='T';LCD_Data(); 
        amount=4;
        AmountRial[0]='1';
        AmountRial[1]='0';
        AmountRial[2]='0';
        AmountRial[3]='0';
        AmountRial[4]='0';
        AmountRial[5]='0';
        AmountRial[6]=',';
        AmountCS=0x01;//check sum
        }
if( a == 5)
        {
        To_LCD='2';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=',';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD='0';LCD_Data();
        To_LCD=' ';LCD_Data();
        To_LCD='T';LCD_Data();
        amount=5; 
        AmountRial[0]='2';
        AmountRial[1]='0';
        AmountRial[2]='0';
        AmountRial[3]='0';
        AmountRial[4]='0';
        AmountRial[5]='0';
        AmountRial[6]=',';
        AmountCS=0x02; //check sum
        }
}
/********************************************************************************/
/*                     POS LCD comment                                          */
/********************************************************************************/
void PressOK()
{
To_LCD=Clear_LCD;        
LCD_Cmnd();
To_LCD='P';LCD_Data();
To_LCD='R';LCD_Data();
To_LCD='E';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD=' ';LCD_Data();
To_LCD='O';LCD_Data();
To_LCD='K';LCD_Data(); 
To_LCD='.';LCD_Data(); 
To_LCD=DisplayOn_CursorOff;
LCD_Cmnd();
}
/********************************************************************************/
/*                     POS LCD comment                                          */
/********************************************************************************/
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
/********************************************************************************/
/*                     POS LCD comment                                          */
/********************************************************************************/
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
To_LCD=DisplayOn_CursorBlinking;
LCD_Cmnd();
menu=0;
}
/********************************************************************************/
/*                     POS LCD comment                                          */
/********************************************************************************/
void ExitMenu()
{
To_LCD=Clear_LCD;        
LCD_Cmnd();
To_LCD='P';LCD_Data();
To_LCD='R';LCD_Data();
To_LCD='E';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD='S';LCD_Data(); 
To_LCD=' ';LCD_Data();
To_LCD='O';LCD_Data(); 
To_LCD='K';LCD_Data();
To_LCD=' ';LCD_Data(); 
To_LCD='T';LCD_Data();
To_LCD='O';LCD_Data(); 
To_LCD=' ';LCD_Data();
To_LCD='E';LCD_Data(); 
To_LCD='X';LCD_Data();
To_LCD='I';LCD_Data(); 
To_LCD='T';LCD_Data();
}
/********************************************************************************/
/*                     POS LCD comment                                          */
/********************************************************************************/
void POSMenu()
{
To_LCD=Clear_LCD;
LCD_Cmnd();
To_LCD='P';LCD_Data();
To_LCD='O';LCD_Data();
To_LCD='S';LCD_Data();
To_LCD=':';LCD_Data();
}
/********************************************************************************/
/*                     POS set                                                  */
/********************************************************************************/
#define ACTIVE     2
#define DISACTIVE  1
void POSSet(char a)
{
if(a == 1)
        {
        To_LCD='D';LCD_Data();
        To_LCD='i';LCD_Data();
        To_LCD='s';LCD_Data();
        To_LCD='a';LCD_Data();
        To_LCD='b';LCD_Data();
        To_LCD='l';LCD_Data();
        To_LCD='e';LCD_Data();
        pos=1;
        }
if(a == 2)
        {
        To_LCD='E';LCD_Data();
        To_LCD='n';LCD_Data();
        To_LCD='a';LCD_Data();
        To_LCD='b';LCD_Data();
        To_LCD='l';LCD_Data();
        To_LCD='e';LCD_Data();
        pos=2;
        }
}
/********************************************************************************/
/*                      LCD Menu  OK Key                                        */
/********************************************************************************/
void LCDMenu(void)
{
char cnt=0,men=0,inch=0;
char i=0,j=0;                     
cnt=0x30;i=0;                              
EnterPass();   //Enter Pass 
Start_Key_Light=Disable;
while(menu<6)
        {
        while(menu == 0)   // Pass Menu
                {
                if(men == 1)
                        {
                        cnt=0x30;i=0;                              
                        EnterPass();
                        men=0;
                        }
                if(DN)    //Down Key    
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(DN); 
                        if(cnt>0x30)
                                cnt--;
                        To_LCD=Clear_LCD;
                        LCD_Cmnd();
                        for(j=0;j<i;j++)
                                {
                                To_LCD='*';
                                LCD_Data();
                                }
                        To_LCD=DisplayOn_CursorOff;
                        LCD_Cmnd();
                        To_LCD=cnt;
                        LCD_Data();
                        }
                if(UP)        // Up Key
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(UP);
                        if(cnt<0x39)
                                cnt++;
                        To_LCD=Clear_LCD;
                        LCD_Cmnd(); 
                        for(j=0;j<i;j++)
                                {
                                To_LCD='*';
                                LCD_Data();
                                }
                        To_LCD=DisplayOn_CursorOff;
                        LCD_Cmnd();
                        To_LCD=cnt;
                        LCD_Data();
                        }
                if(OK_Key)     // OK Key
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        i++;            
                        while(OK_Key);
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
                                        menu=5;
                                        men=1;
                                        cnt=3;
                                        LCD_Buzz_On;
                                        delay_ms(100);
                                        LCD_Buzz_Off;
                                        LCD_Buzz_On;
                                        delay_ms(100);
                                        LCD_Buzz_Off;
                                        break;
                                        }
                                else
                                        { 
                                        ErrorPass();
                                        LCD_Buzz_On;
                                        delay_ms(100);
                                        LCD_Buzz_Off;
                                        delay_ms(1000);
                                        men=1;
                                        }  
                                }//if(i==4)
                        }//if(OK)
                }//while(menu==0)
        while(menu == 5)  // Main Menu 
                {             
                if(cnt == 3 && men == 1)
                        {
                        AmountMenu();
                        AmountSet(amount);
                        men=0;
                        }
                if(cnt == 2 && men == 1)
                        {
                        TimeMenu();
                        TimeSet(time);
                        men=0;
                        }
                if(cnt == 1 && men == 1)
                        {
                        POSMenu();
                        POSSet(pos);
                        men=0;
                        }
                if(cnt == 0 && men == 1)
                        {
                        ExitMenu();
                        men=0;
                        }
                if(DN)         
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(DN); 
                        if(cnt>0)
                                cnt--;
                        men=1;
                        }
                if(UP)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(UP);
                        if(cnt<3)
                                cnt++; 
                        men=1;
                        }
                if(OK_Key)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(OK_Key);
                        menu=cnt;
                        if(menu == 0)
                                {
                                menu=6;
                                To_LCD=Clear_LCD;
                                LCD_Cmnd();
                                LCD_Buzz_On;
                                delay_ms(1000);
                                LCD_Buzz_Off;
                                PressOK();   
                                Start_Key_Light=Enable;
                                }
                        cnt=1;
                        men=1;
                        To_LCD=DisplayOn_CursorBlinking;
                        LCD_Cmnd();
                        break;        
                        }
                 }       
        while(menu == 3) //Amount Menu
                {
                if(cnt == 1 && men == 1) // 1000 T  amount=1
                        {
                        AmountMenu();
                        AmountSet(cnt);
                        men=0;
                        }
                if(cnt == 2 && men == 1) // 2000 T  amount=2
                        {
                        AmountMenu();   
                        AmountSet(cnt);
                        men=0;
                        }
                if(cnt == 3 && men == 1) // 5000 T    amount=3
                        {
                        AmountMenu();   
                        AmountSet(cnt);
                        men=0;
                        }
                if(cnt == 4 && men == 1)  // 10,000 T   amount=4
                        {
                        AmountMenu();   
                        AmountSet(cnt);
                        men=0;
                        }
                if(cnt == 5 && men == 1)  // 20,000 T    amount=5
                        {
                        AmountMenu();   
                        AmountSet(cnt);  
                        men=0;
                        }
                if(DN)         
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(DN); 
                        if(cnt>1)
                                cnt--;
                        men=1;
                        }
                if(UP)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(UP);
                        if(cnt<5)
                                cnt++; 
                        men=1;
                        }
                if(OK_Key)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(OK_Key);
                        amount=cnt; 
                        AmountMenu();
                        AmountSet(amount);
                        To_LCD=' ';
                        LCD_Data();
                        To_LCD='O';
                        LCD_Data();
                        To_LCD='K';
                        LCD_Data();
                        To_LCD=DisplayOn_CursorOff;
                        LCD_Cmnd();
                        menu=5;
                        men=1;
                        cnt=3;
                        break;        
                        }
                }
        while(menu == 2) //Time Menu 
                {
                if(cnt == 1 && men == 1)    // 30sec time=1
                        {
                        TimeMenu();
                        TimeSet(cnt);
                        men=0;
                        }
                if(cnt == 2 && men == 1)   // 45sec time=2
                        {
                        TimeMenu();
                        TimeSet(cnt);
                        men=0;
                        }
                if(cnt == 3 && men == 1)   // 60sec time=3
                        {
                        TimeMenu();
                        TimeSet(cnt);
                        men=0;
                        }
                if(cnt == 4 && men == 1)   // 90sec time=4
                        {
                        TimeMenu();
                        TimeSet(cnt);
                        men=0;
                        }
                if(DN)         
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(DN); 
                        if(cnt>1)
                                cnt--;
                        men=1;
                        }
                if(UP)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(UP);
                        if(cnt<4)
                                cnt++; 
                        men=1;
                        }
                if(OK_Key)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(OK_Key);
                        time=cnt;
                        TimeMenu();
                        TimeSet(time);
                        To_LCD=' ';
                        LCD_Data();
                        To_LCD='O';
                        LCD_Data();
                        To_LCD='K';
                        LCD_Data();
                         
                        To_LCD=DisplayOn_CursorOff;
                        LCD_Cmnd();
                        delay_ms(2000);
                        menu=5;
                        men=1;
                        cnt=2;
                        break;        
                        }
                }
        while(menu == 1) //POS ability menu
                {
                if(cnt == 2 && men == 1)  //POS Enable  pos=2
                        {
                        POSMenu();
                        POSSet(cnt);
                        men=0;
                        }
                if(cnt == 1 && men == 1) //POS Disable  pos=1
                        {         
                        POSMenu();
                        POSSet(cnt);
                        men=0;
                        }
                if(DN)         
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(DN); 
                        if(cnt>1)
                                cnt--;
                        men=1;
                        }
                if(UP)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(UP);
                        if(cnt<2)
                                cnt++; 
                        men=1;
                        }
                if(OK_Key)
                        {
                        LCD_Buzz_On;
                        delay_ms(100);
                        LCD_Buzz_Off;
                        while(OK_Key);
                        To_LCD=DisplayOn_CursorOff;
                        LCD_Cmnd();
                        menu=5;
                        men=1;
                        cnt=1;
                        break;        
                        }
                }
        }
}
/********************************************************************************/
/*                      Hurricane Simulation routine                            */
/********************************************************************************/
#define WaitStart       6
void Hurricane(void)
        {
        int i; 
        hdone=0;
        count=0;
        Start_Key_Light=Disable;// Start LED disactivated
        POS_Error_Light_Off;  // Error light off
        if(time == 1) Timer1Sec=30;
        if(time == 2) Timer1Sec=45;
        if(time == 3) Timer1Sec=60;
        if(time == 4) Timer1Sec=90;
        for(i=0;i<WaitStart;i++) // wait for user come in //10 sec
                {
                LFTDIG=0;RGTDIG=0;
                Display_Buzz=ON;
                delay_ms(100);
                if(time == 1) {LFTDIG=SVNSG[3];RGTDIG=SVNSG[0];}
                if(time == 2) {LFTDIG=SVNSG[4];RGTDIG=SVNSG[5];}
                if(time == 3) {LFTDIG=SVNSG[6];RGTDIG=SVNSG[0];}
                if(time == 4) {LFTDIG=SVNSG[9];RGTDIG=SVNSG[0];}
                Display_Buzz=OFF;
                delay_ms(800);
                }
        Display_Buzz=ON; // final start alarm
        delay_ms(1500);
        Display_Buzz=OFF;
        count=1;       // Cabine counter enable
        Cabine_Light_Off;
        Speaker_On;               
        Head_Light=Disable;
        Motor=Enable;  //Motor ON
        while(!hdone);            
        Motor=Disable; //Motor OFF
        Speaker_Off;                   
        count=0;
        //Head_Light=Enable;
        Cabine_Light_On;
        Display_Buzz=ON;  // end note
        delay_ms(200);
        Display_Buzz=OFF;         
        Start_Key_Light=Enable;
        }  
/********************************************************************************/
/*                      Start Key_Activate POS                                  */
/********************************************************************************/
void POS_Service(void)
{
char i,cnt1,cnt2,j;
char CSN=0,CSN1=0,CSN2=0;
MessageID[1]='1'; 
CSN=(~AmountCS&0x6d)|(AmountCS&0x92);
//IDMess++;  //Invoice Number Active
IDMess=1;  //Invoice Number Disactive
MessageID[0]=IDMess/10+48;
MessageID[1]=IDMess%10+48; 
CheckSumNum[0]=CSN/16;
if(CheckSumNum[0]>=10)
        CheckSumNum[0]+=55;
if(CheckSumNum[0]<10)
        CheckSumNum[0]+=48;
CheckSumNum[1]=CSN%16;
if(CheckSumNum[1]>=10)
        CheckSumNum[1]+=55;
if(CheckSumNum[1]<10)
        CheckSumNum[1]+=48;
//delay_ms(100); 
for(j=0;j<7;j++)// Start of command
        putchar1(BuyCommand[j]);
j=0; // amount Rials: max 999,999 rials
while(AmountRial[j]!=',')
        {
        putchar1(AmountRial[j]);
        j++;
        }
putchar1(',');                
if(IDMess<10) // Invoice Number 
        putchar1(MessageID[1]);
if(IDMess>=10)
        for(j=0;j<2;j++)      
                putchar1(MessageID[j]);
for(j=0;j<16;j++)      //date YYMMDDHHMMSS
        putchar1(DateTimeD[j]);
if(IDMess<10) // MessageID 
        putchar1(MessageID[1]);
if(IDMess>=10)
        for(j=0;j<2;j++)      
                putchar1(MessageID[j]);
for(j=0;j<4;j++)      // 
        putchar1(EndOfCommand[j]);
for(j=0;j<2;j++)      // 
        putchar1(CheckSumNum[j]);
for(j=4;j<6;j++)      // 
        putchar1(EndOfCommand[j]);
delay_ms(1000);
for(j=0;j<32;j++)
        RecMess[j]=0xff;
while(RecMess[0] != '$')
        RecMess[0]=getchar1();
for(j=1;j<32;j++)
        RecMess[j]=getchar1();
if(RecMess[1] == 'P' && RecMess[2]=='O' && RecMess[3]=='S')
        {
        if(RecMess[8] == 0x30)  // OK paid
                {
                Hurricane();
                }
        else
                {
                POS_Error_Light_On;
                }
        }//if POS     
}
/********************************************************************************/
/*                      Timer 0 overflow interrupt                              */
/********************************************************************************/
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{ 
TCNT0=256-11;					//16Mhz/128(Prescaler)/125 = 1000Hz
TimeCnt++;
if(TimeCnt%2 == 0)
        {
        RGTDIG_Off;
        LFTDIG_On;
        SVNSG_PORT=LFTDIG;   
        }
if(TimeCnt%2 == 1)
        {
        LFTDIG_Off;
        RGTDIG_On;
        SVNSG_PORT=RGTDIG;
        }
//////////////////////////////LIGHTING///////////////////////
if(count)
        {
        //Cabine_Light_Off;//Lighting=Disable;
        if(TimeCnt == 100)
                Cabine_Light_On;//Lighting=Enable;
        if(TimeCnt == 180)
                Cabine_Light_Off;//Lighting=Disable;
        if(TimeCnt == 200)
                Cabine_Light_On;//Lighting=Enable;
        if(TimeCnt == 250)
                Cabine_Light_Off;//Lighting=Disable;
        if(TimeCnt == 400)
                Cabine_Light_On;//Lighting=Enable;
        if(TimeCnt == 500)
                Cabine_Light_Off;//Lighting=Disable;
        }
/////////////////////////////////////////////////////////////
  

if(TimeCnt == 982 ) //981.8181
        {
        Head_Light=~Head_Light;
        
        if(Timer1Sec>0 && count)
                Timer1Sec--;
        if(Timer1Sec == 0 && count)
                {
                hdone=1; 
                }
        if(count)
                {
//                 if(Timer1Sec>=10)
//                         {
                        LFTDIG=SVNSG[Timer1Sec/10];
                        RGTDIG=SVNSG[Timer1Sec%10];
                       // }
//                 if(Timer1Sec<10)
//                         {
//                         LFTDIG=0x00;
//                         RGTDIG=SVNSG[Timer1Sec];
//                         }
                }
        TimeCnt=0;
        MOS2=~MOS2;  // system working indicator flashes to show system is working (SYSTEM HEART)
        }
}
/********************************************************************************/
/*                      Initialition of MCU                                     */
/********************************************************************************/
void Init(void)
{  
PORTA=0xFF;DDRA=0xFF;PORTB=0x00;DDRB=0xFF;  
PORTC=0x00;DDRC=0xFF;PORTD=0x80;DDRD=0x80;
PORTE=0x00;DDRE=0xF0;//1111 0000
PORTF=0xCF;DDRF=0xCF;   
PORTG=0x00;DDRG=0x07;    // 0000 0111   in in x rgtdig lftdig
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 10.800 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
ASSR=0x00;TCCR0=0x07;TCNT0=0x00;OCR0=0x00;
TCCR1A=0x00;		//Timer/Counter Control Register 1A
TCCR1B=0x00;		//Timer/Counter Control Register 1B
TCNT1H=0x00;		//Timer/Counter Register 1H
TCNT1L=0x00;		//Timer/Counter Register 1L
OCR1AH=0x00;		//Output Capture Register 1AH
OCR1AL=0x00;		//Output Capture Register 1AL
OCR1BH=0x00;		//Output Capture Register 1BH
OCR1BL=0x00;		//Output Capture Register 1BL
// External Interrupt(s) initialization
// INT0: Off// INT1: Off// INT2: Off// INT3: Off// INT4: Off// INT5: Off// INT6: Off// INT7: Off
EICRA=0x00;EICRB=0x00;EIMSK=0x00;
// MCUCR |= 0x80;		//MCU Control Register 
// XMCRA |= 0x02;		//external ram wait state
// XMCRB = 0x80;
TIMSK=0x01;TIFR=0x00;			// Timer/Counter Interrupt Flag Register
/// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: Off
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=0x00;UCSR0B=0x10;UCSR0C=0x06;UBRR0H=0x00;UBRR0L=0x67;
// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 115200
UCSR1A=0x00;UCSR1B=0x18;UCSR1C=0x06;UBRR1H=0x00;UBRR1L=0x05;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

To_LCD=Use_Matrix;LCD_Cmnd();
To_LCD=Return_Home;LCD_Cmnd();
LCD_Buzz_Off;
Display_Buzz=OFF;
Cabine_Light_On;
Speaker_Off;
POS_Error_Light_Off;
Start_Key_Light=Enable;
Head_Light=Enable;
Relay6=Disable;
Motor=Disable;
Relay8=Disable;  
MOS2=Disable;
Lighting=Disable;
menu=0;count=0;Timer1Sec=0;hdone=0;menu_set=0; 
IDMess=1;//invoice number 
LFTDIG=SVNSG[0];
RGTDIG=SVNSG[0];// left and right digit have showen nothing
// AmountRial[0]='1';     //test amount to 1000 rials
// AmountRial[1]='0';
// AmountRial[2]='0';
// AmountRial[3]='0';
// AmountRial[4]=',';
// AmountCS=0x01; //check sum 
}
/********************************************************************************/
/*                                Main routine                                  */
/********************************************************************************/
void main(void)
{          
char inch;           
char cnt=0,men=0;
char i=0,cnt1,cnt2,j=0;
Init();
#asm("sei");        //default status:       
AmountSet(To1000T); // Amount set to 2000 Toman
TimeSet(To30Sec);   // Time set to 30 sec.
POSSet(ACTIVE);     // POS active
PressOK();
while(1)
        {
        if(Start_Key)
                {
                Display_Buzz=ON;
                delay_ms(100);
                Display_Buzz=OFF;
                while(Start_Key);
                //Cabine_Light_On;
                if(pos == ACTIVE)
                        {
                        POS_Service();
                        }
                if(pos == DISACTIVE)
                        {
                        Hurricane();
                        }
                }// if(Start_Key)  
        if(OK_Key)
                {
                LCD_Buzz_On;
                delay_ms(100);
                LCD_Buzz_Off;
                while(OK_Key);
                LCDMenu();
                }
       }//while(1)
}//main

                                      
