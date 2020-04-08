
;CodeVisionAVR C Compiler V1.25.8 Standard
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "test.vec"
	.INCLUDE "test.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.25.8 Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project :
;       9 Version :
;      10 Date    : 2016/01/26
;      11 Author  : Radfar
;      12 Company : MTAG
;      13 Comments:
;      14 
;      15 
;      16 Chip type           : ATmega32
;      17 Program type        : Application
;      18 Clock frequency     : 8.000000 MHz
;      19 Memory model        : Small
;      20 External SRAM size  : 0
;      21 Data Stack size     : 512
;      22 *****************************************************/
;      23 
;      24 #include <mega32.h>
;      25 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      26 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      27 	.EQU __se_bit=0x80
	.EQU __se_bit=0x80
;      28 	.EQU __sm_mask=0x70
	.EQU __sm_mask=0x70
;      29 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;      30 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;      31 	.EQU __sm_standby=0x60
	.EQU __sm_standby=0x60
;      32 	.EQU __sm_ext_standby=0x70
	.EQU __sm_ext_standby=0x70
;      33 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;      34 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      35 	#endif
	#endif
;      36 #include "delay.h"
;      37 #define left   0x01
;      38 #define right  0x02
;      39 #define To_LCD    PORTA
;      40 #define RS      PORTB.0
;      41 #define RW      PORTB.1
;      42 #define En      PORTB.2
;      43 #define BL      PORTB.3
;      44 #define UP      PIND.0
;      45 #define OK      PIND.1
;      46 #define DN      PIND.2
;      47 
;      48 /******************************/
;      49 #define Clear_LCD 			0x01
;      50 #define Return_Home 			0x02
;      51 #define Shift_Cursor_Left		0x04
;      52 #define Shift_Cursor_Right		0x06
;      53 #define Shift_Display_Left		0x05
;      54 #define Shift_Display_Right		0x07
;      55 #define DisplayOff_CursorOff		0x08
;      56 #define DisplayOff_CursorOn 		0x0a
;      57 #define DisplayOn_CursorOff    		0x0c
;      58 #define DisplayOn_CursorOn		0x0e
;      59 #define DisplayOn_CursorBlinking	0x0f
;      60 #define Use_Matrix			0x38
;      61 
;      62 
;      63 // Declare your global variables here
;      64 char SVNSG[10]={0x7e,0x30,0xed,0xf9,0x33,0xdb,0xdf,0xf0,0xff,0xfb};
_SVNSG:
	.BYTE 0xA
;      65 char Sel[8]={0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};
_Sel:
	.BYTE 0x8
;      66 char Pass[4]={0,0,0,0};
_Pass:
	.BYTE 0x4
;      67 char menu=0,amount=1,time=3;
;      68 bit pos=1;
;      69 //flash char PASSOK[4]={1,2,4,8};
;      70 /******************************/
;      71 void LCD_Cmnd (void)
;      72 {

	.CSEG
_LCD_Cmnd:
;      73 RS=0;RW=0;En=1;
	CBI  0x18,0
	RCALL SUBOPT_0x0
;      74 delay_ms(2);
;      75 RS=0;RW=0;En=0;
	CBI  0x18,0
	RCALL SUBOPT_0x1
;      76 delay_ms(2);
;      77 }
	RET
;      78 /******************************/
;      79 void LCD_Data (void)
;      80 {
_LCD_Data:
;      81 RS=1;RW=0;En=1;
	SBI  0x18,0
	RCALL SUBOPT_0x0
;      82 delay_ms(2);
;      83 RS=1;RW=0;En=0;
	SBI  0x18,0
	RCALL SUBOPT_0x1
;      84 delay_ms(2);
;      85 }
	RET
;      86 /********************************/
;      87 void PassOK()
;      88 {
_PassOK:
;      89 To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;      90 LCD_Cmnd();
;      91 To_LCD='P';LCD_Data();
	RCALL SUBOPT_0x3
;      92 To_LCD='A';LCD_Data();
;      93 To_LCD='S';LCD_Data();
;      94 To_LCD='S';LCD_Data();
;      95 To_LCD=' ';LCD_Data();
	RCALL SUBOPT_0x4
;      96 To_LCD='O';LCD_Data();
	RCALL SUBOPT_0x5
;      97 To_LCD='K';LCD_Data();
	LDI  R30,LOW(75)
	OUT  0x1B,R30
	RCALL _LCD_Data
;      98 }
	RET
;      99 /********************************/
;     100 void ErrorPass()
;     101 {
_ErrorPass:
;     102 To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;     103 LCD_Cmnd();
;     104 To_LCD='E';LCD_Data();
	RCALL SUBOPT_0x6
;     105 To_LCD='R';LCD_Data();
	RCALL SUBOPT_0x7
;     106 To_LCD='R';LCD_Data();
	RCALL SUBOPT_0x7
;     107 To_LCD='O';LCD_Data();
	RCALL SUBOPT_0x5
;     108 To_LCD='R';LCD_Data();
	RCALL SUBOPT_0x7
;     109 To_LCD=' ';LCD_Data();
	RCALL SUBOPT_0x4
;     110 To_LCD='P';LCD_Data();
	RCALL SUBOPT_0x3
;     111 To_LCD='A';LCD_Data();
;     112 To_LCD='S';LCD_Data();
;     113 To_LCD='S';LCD_Data();
;     114 }
	RET
;     115 /********************************/
;     116 void EnterPass()
;     117 {
_EnterPass:
;     118 To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;     119 LCD_Cmnd();
;     120 To_LCD='E';LCD_Data();
	RCALL SUBOPT_0x6
;     121 To_LCD='N';LCD_Data();
	LDI  R30,LOW(78)
	OUT  0x1B,R30
	RCALL _LCD_Data
;     122 To_LCD='T';LCD_Data();
	LDI  R30,LOW(84)
	OUT  0x1B,R30
	RCALL _LCD_Data
;     123 To_LCD='E';LCD_Data();
	RCALL SUBOPT_0x6
;     124 To_LCD='R';LCD_Data();
	RCALL SUBOPT_0x7
;     125 To_LCD=' ';LCD_Data();
	RCALL SUBOPT_0x4
;     126 To_LCD='P';LCD_Data();
	RCALL SUBOPT_0x3
;     127 To_LCD='A';LCD_Data();
;     128 To_LCD='S';LCD_Data();
;     129 To_LCD='S';LCD_Data();
;     130 To_LCD=':';LCD_Data();
	RCALL SUBOPT_0x8
;     131 To_LCD=DisplayOn_CursorOff;
	LDI  R30,LOW(12)
	OUT  0x1B,R30
;     132 LCD_Cmnd();
	RCALL _LCD_Cmnd
;     133 menu=0;
	CLR  R5
;     134 }
	RET
;     135 /***************************************/
;     136 void POS_En()
;     137 {
_POS_En:
;     138 To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;     139 LCD_Cmnd();
;     140 To_LCD='P';LCD_Data();
	RCALL SUBOPT_0x9
;     141 To_LCD='O';LCD_Data();
;     142 To_LCD='S';LCD_Data();
	RCALL SUBOPT_0xA
;     143 To_LCD=':';LCD_Data();
;     144 To_LCD=' ';LCD_Data();
	RCALL SUBOPT_0x4
;     145 To_LCD='E';LCD_Data();
	RCALL SUBOPT_0x6
;     146 To_LCD='n';LCD_Data();
	LDI  R30,LOW(110)
	RCALL SUBOPT_0xB
;     147 To_LCD='a';LCD_Data();
;     148 To_LCD='b';LCD_Data();
;     149 To_LCD='l';LCD_Data();
;     150 To_LCD='e';LCD_Data();
;     151 pos=1;
	SET
	BLD  R2,0
;     152 }
	RET
;     153 /***************************************/
;     154 void POS_Dis()
;     155 {
_POS_Dis:
;     156 To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;     157 LCD_Cmnd();
;     158 To_LCD='P';LCD_Data();
	RCALL SUBOPT_0x9
;     159 To_LCD='O';LCD_Data();
;     160 To_LCD='S';LCD_Data();
	RCALL SUBOPT_0xA
;     161 To_LCD=':';LCD_Data();
;     162 To_LCD=' ';LCD_Data();
	RCALL SUBOPT_0x4
;     163 To_LCD='D';LCD_Data();
	LDI  R30,LOW(68)
	OUT  0x1B,R30
	RCALL _LCD_Data
;     164 To_LCD='i';LCD_Data();
	LDI  R30,LOW(105)
	OUT  0x1B,R30
	RCALL _LCD_Data
;     165 To_LCD='s';LCD_Data();
	LDI  R30,LOW(115)
	RCALL SUBOPT_0xB
;     166 To_LCD='a';LCD_Data();
;     167 To_LCD='b';LCD_Data();
;     168 To_LCD='l';LCD_Data();
;     169 To_LCD='e';LCD_Data();
;     170 pos=0;
	CLT
	BLD  R2,0
;     171 }
	RET
;     172 /*******************************/
;     173 void Init()
;     174 {
_Init:
;     175 PORTA=0x00;DDRA=0xFF;PORTB=0x00;DDRB=0xff;PORTC=0x00;DDRC=0xFF;PORTD=0x00;DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(255)
	OUT  0x14,R30
	LDI  R30,LOW(0)
	OUT  0x12,R30
	OUT  0x11,R30
;     176 TCCR0=0x00;TCNT0=0x00;OCR0=0x00;TCCR1A=0x00;TCCR1B=0x00;TCNT1H=0x00;TCNT1L=0x00;ICR1H=0x00;
	OUT  0x33,R30
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x2F,R30
	OUT  0x2E,R30
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x27,R30
;     177 ICR1L=0x00;OCR1AH=0x00;OCR1AL=0x00;OCR1BH=0x00;OCR1BL=0x00;ASSR=0x00;TCCR2=0x00;TCNT2=0x00;OCR2=0x00;
	OUT  0x26,R30
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
	OUT  0x22,R30
	OUT  0x25,R30
	OUT  0x24,R30
	OUT  0x23,R30
;     178 MCUCR=0x00;MCUCSR=0x00;TIMSK=0x00;ACSR=0x80;SFIOR=0x00;
	OUT  0x35,R30
	OUT  0x34,R30
	OUT  0x39,R30
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     179 To_LCD=Use_Matrix;LCD_Cmnd();
	LDI  R30,LOW(56)
	OUT  0x1B,R30
	RCALL _LCD_Cmnd
;     180 To_LCD=Return_Home;LCD_Cmnd();
	LDI  R30,LOW(2)
	OUT  0x1B,R30
	RCALL _LCD_Cmnd
;     181 menu=0;    //0:password   1:Amount  2:Time Duration  3.POS enabled
	CLR  R5
;     182 pos=1;     //pos=0: pos disable     pos=1: pos enable
	SET
	BLD  R2,0
;     183 amount=1;  //0:1000t   1:2000t  2:5000t   3:10000t  4.20000t
	LDI  R30,LOW(1)
	MOV  R4,R30
;     184 time=3;    //0:30sec  1:45sec   2:60sec   3:90sec
	LDI  R30,LOW(3)
	MOV  R7,R30
;     185 }
	RET
;     186 
;     187 /*************************************************/
;     188 void main(void)
;     189 {
_main:
;     190 unsigned int cnt=0;
;     191 char i=0,j=0;
;     192 Init();
;	cnt -> R16,R17
;	i -> R19
;	j -> R18
	LDI  R16,0
	LDI  R17,0
	LDI  R18,0
	LDI  R19,0
	RCALL _Init
;     193 cnt=0x30;i=0;
	__GETWRN 16,17,48
	LDI  R19,LOW(0)
;     194 EnterPass();
	RCALL _EnterPass
;     195 while(1)
_0x1F:
;     196 {
;     197 while(menu == 0)
_0x22:
	TST  R5
	BREQ PC+3
	JMP _0x24
;     198         {
;     199         if(DN)
	SBIS 0x10,2
	RJMP _0x25
;     200                 {
;     201                 delay_ms(150);
	RCALL SUBOPT_0xC
;     202                 while(DN);
_0x26:
	SBIC 0x10,2
	RJMP _0x26
;     203                 if(cnt>0x30)
	__CPWRN 16,17,49
	BRLO _0x29
;     204                         cnt--;
	__SUBWRN 16,17,1
;     205                 To_LCD=Clear_LCD;
_0x29:
	RCALL SUBOPT_0x2
;     206                 LCD_Cmnd();
;     207                 To_LCD=cnt;
	MOVW R30,R16
	OUT  0x1B,R30
;     208                 LCD_Data();
	RCALL _LCD_Data
;     209                 }
;     210         if(UP)
_0x25:
	SBIS 0x10,0
	RJMP _0x2A
;     211                 {
;     212                 delay_ms(150);
	RCALL SUBOPT_0xC
;     213                 while(UP);
_0x2B:
	SBIC 0x10,0
	RJMP _0x2B
;     214                 if(cnt<0x39)
	__CPWRN 16,17,57
	BRSH _0x2E
;     215                         cnt++;
	__ADDWRN 16,17,1
;     216                 To_LCD=Clear_LCD;
_0x2E:
	RCALL SUBOPT_0x2
;     217                 LCD_Cmnd();
;     218                 To_LCD=cnt;
	MOVW R30,R16
	OUT  0x1B,R30
;     219                 LCD_Data();
	RCALL _LCD_Data
;     220                 }
;     221         if(OK)
_0x2A:
	SBIS 0x10,1
	RJMP _0x2F
;     222                 {
;     223                 i++;
	SUBI R19,-1
;     224                 delay_ms(150);
	RCALL SUBOPT_0xC
;     225                 while(OK);
_0x30:
	SBIC 0x10,1
	RJMP _0x30
;     226                 Pass[i-1]=cnt;
	MOV  R30,R19
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_Pass)
	SBCI R31,HIGH(-_Pass)
	ST   Z,R16
;     227                 cnt=0x30;
	__GETWRN 16,17,48
;     228                 To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;     229                 LCD_Cmnd();
;     230                 for(j=0;j<i;j++)
	LDI  R18,LOW(0)
_0x34:
	CP   R18,R19
	BRSH _0x35
;     231                         {
;     232                         To_LCD='*';
	LDI  R30,LOW(42)
	OUT  0x1B,R30
;     233                         LCD_Data();
	RCALL _LCD_Data
;     234                         }
	SUBI R18,-1
	RJMP _0x34
_0x35:
;     235                 if(i==4)
	CPI  R19,4
	BRNE _0x36
;     236                         {
;     237                         if(Pass[0]==0x31 && Pass[1]==0x32 && Pass[2]==0x31 && Pass[3]==0x33) //pass:1213
	LDS  R26,_Pass
	CPI  R26,LOW(0x31)
	BRNE _0x38
	__GETB1MN _Pass,1
	CPI  R30,LOW(0x32)
	BRNE _0x38
	__GETB1MN _Pass,2
	CPI  R30,LOW(0x31)
	BRNE _0x38
	__GETB1MN _Pass,3
	CPI  R30,LOW(0x33)
	BREQ _0x39
_0x38:
	RJMP _0x37
_0x39:
;     238                                 {
;     239                                 PassOK();
	RCALL _PassOK
;     240                                 //delay_ms(2000);
;     241                                 menu=5;
	LDI  R30,LOW(5)
	MOV  R5,R30
;     242                                 }
;     243                         else
	RJMP _0x3A
_0x37:
;     244                                 {
;     245                                 ErrorPass();
	RCALL _ErrorPass
;     246                                 i=0;
	LDI  R19,LOW(0)
;     247                                 cnt=0x30;
	__GETWRN 16,17,48
;     248                                 delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     249                                 EnterPass();
	RCALL _EnterPass
;     250                                 }
_0x3A:
;     251                         }//if(i==4)
;     252                 }//if(OK)
_0x36:
;     253         }//while(menu==0)
_0x2F:
	RJMP _0x22
_0x24:
;     254 while(menu == 1) //Amount Menu
_0x3B:
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x3B
;     255         {
;     256 
;     257         }
;     258 while(menu == 2) //Time Menu
_0x3E:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x40
;     259 while(menu == 3) //POS ability menu
_0x41:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x43
;     260         {
;     261         POS_En();
	RCALL _POS_En
;     262         do      {
_0x45:
;     263                 if(DN)
	SBIS 0x10,2
	RJMP _0x47
;     264                         {
;     265                         delay_ms(150);
	RCALL SUBOPT_0xC
;     266                         while(DN);
_0x48:
	SBIC 0x10,2
	RJMP _0x48
;     267                         POS_Dis();
	RCALL _POS_Dis
;     268                         }
;     269                 if(UP)
_0x47:
	SBIS 0x10,0
	RJMP _0x4B
;     270                         {
;     271                         delay_ms(150);
	RCALL SUBOPT_0xC
;     272                         while(UP);
_0x4C:
	SBIC 0x10,0
	RJMP _0x4C
;     273                         To_LCD=Clear_LCD;
	RCALL SUBOPT_0x2
;     274                         LCD_Cmnd();
;     275                         POS_En();
	RCALL _POS_En
;     276                         }
;     277                 }while(!OK);
_0x4B:
	SBIS 0x10,1
	RJMP _0x45
;     278         if(OK)
	SBIS 0x10,1
	RJMP _0x4F
;     279                 {
;     280                 delay_ms(150);
	RCALL SUBOPT_0xC
;     281                 while(OK);
_0x50:
	SBIC 0x10,1
	RJMP _0x50
;     282                 menu=5;  //exit from menu
	LDI  R30,LOW(5)
	MOV  R5,R30
;     283                 break;
	RJMP _0x43
;     284                 }
;     285          }
_0x4F:
	RJMP _0x41
_0x43:
	RJMP _0x3E
_0x40:
;     286 }
	RJMP _0x1F
;     287 
;     288 
;     289 //while(1)
;     290 //delay_ms(3000);
;     291         //BL=0;
;     292 //       cnt++;
;     293 //       if(cnt==27)
;     294 //         {
;     295 //         cnt=0;
;     296 //         i++;
;     297 //         if(i==10)
;     298 //                 {
;     299 //                 j++;
;     300 //                 i=0;
;     301 //                 if(j==10)
;     302 //                         j=0;
;     303 //                 }
;     304 //         }
;     305 //       //for(i=0;i<10;i++)
;     306 //       //{
;     307 //       PORTD=left;
;     308 //       PORTC=SVNSG[j];
;     309 //       delay_ms(5);
;     310 //       PORTD=right;
;     311 //       PORTC=SVNSG[i];
;     312 //       delay_ms(5);
;     313       //}
;     314 //       for(i=0;i<2;i++)
;     315 //         {
;     316 //         PORTA=~Sel[i];
;     317 //         delay_us(100);
;     318 //         PORTB=SVNSG[i];
;     319 //         PORTD=SVNSG[i+1];
;     320 //         delay_us(1900);
;     321 //         }
;     322       //};
;     323 }
_0x53:
	RJMP _0x53


;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	CBI  0x18,1
	SBI  0x18,2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	CBI  0x18,1
	CBI  0x18,2
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	OUT  0x1B,R30
	RJMP _LCD_Cmnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(80)
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(65)
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(83)
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(83)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(32)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(79)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(69)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(82)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(58)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(80)
	OUT  0x1B,R30
	RCALL _LCD_Data
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(83)
	OUT  0x1B,R30
	RCALL _LCD_Data
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xB:
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(97)
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(98)
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(108)
	OUT  0x1B,R30
	RCALL _LCD_Data
	LDI  R30,LOW(101)
	OUT  0x1B,R30
	RJMP _LCD_Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
