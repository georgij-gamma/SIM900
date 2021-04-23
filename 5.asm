
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 4,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _symb=R5
	.DEF _iniflag=R4
	.DEF _Numb=R7
	.DEF _sim900=R6
	.DEF _ATflag=R9
	.DEF _push=R8
	.DEF _pin=R11
	.DEF _rx_wr_index=R10
	.DEF _rx_rd_index=R13
	.DEF _rx_counter=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_my_phone:
	.DB  0x2B,0x37,0x39,0x30,0x39,0x38,0x34,0x35
	.DB  0x30,0x39,0x35,0x33,0x0
_service:
	.DB  0x2B,0x37,0x39,0x30,0x33,0x37,0x30,0x31
	.DB  0x31,0x31,0x31,0x31,0x0
_Ready:
	.DB  0x52,0x65,0x61,0x64,0x79,0x0
_start:
	.DB  0x30,0x33,0x0
_stop:
	.DB  0x30,0x34,0x0
_unlock:
	.DB  0x30,0x32,0x0
_lock:
	.DB  0x30,0x31,0x0
_open_door:
	.DB  0x64,0x6F,0x6F,0x72,0x5F,0x6F,0x70,0x65
	.DB  0x6E,0x0
_crash_door:
	.DB  0x63,0x72,0x61,0x73,0x68,0x5F,0x73,0x65
	.DB  0x6E,0x73,0x0
_error_cmd:
	.DB  0x65,0x72,0x72,0x6F,0x72,0x5F,0x63,0x6D
	.DB  0x64,0x0
_car_lock:
	.DB  0x63,0x61,0x72,0x5F,0x6C,0x6F,0x63,0x6B
	.DB  0x0
_car_unlock:
	.DB  0x63,0x61,0x72,0x5F,0x75,0x6E,0x6C,0x6F
	.DB  0x63,0x6B,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x001F

_0xA0:
	.DB  0x1,0x0,0x0,0x4,0x0,0x1
_0x0:
	.DB  0x41,0x54,0x2B,0x53,0x47,0x50,0x49,0x4F
	.DB  0x3D,0x25,0x64,0x2C,0x25,0x64,0x2C,0x25
	.DB  0x64,0x2C,0x25,0x64,0xD,0xA,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x53,0x3D,0x0
	.DB  0x1A,0xD,0x0,0x41,0x54,0x2B,0x49,0x50
	.DB  0x52,0x3D,0x31,0x39,0x32,0x30,0x30,0xD
	.DB  0x0,0x41,0x54,0x45,0x30,0xD,0x0,0x41
	.DB  0x54,0x56,0x31,0xD,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x45,0x45,0x3D,0x30,0xD,0x0
	.DB  0x41,0x54,0x2B,0x43,0x4C,0x49,0x50,0x3D
	.DB  0x31,0xD,0x0,0x41,0x54,0x2B,0x43,0x53
	.DB  0x43,0x41,0x3D,0x0,0x41,0x54,0x2B,0x43
	.DB  0x53,0x43,0x42,0x3D,0x31,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x46,0x3D,0x31
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x53,0x43
	.DB  0x53,0x3D,0x0,0x47,0x53,0x4D,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x44,0x41,0x3D
	.DB  0x0,0x44,0x45,0x4C,0x20,0x41,0x4C,0x4C
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x04
	.DW  _0xA0*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
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
;#include <m8_128.h>
;#include <stdio.h>
;#include <string.h>
;// #define:
;#define status_SIM PINB.0 // in
;#define pwrkey PORTB.1    // out
;#define check 0
;#define open  1
;#define crash 2
;#define cln   3
;#define read  1
;#define write 0
;#define pin_1 1
;#define pin_2 2
;#define pin_3 3
;#define pin_4 4
;#define pin_5 5
;#define pin_6 6
;#define in    0
;#define out   1
;#define low   0
;#define high  1
;
;#define TOIE1    2 // Timer1
;#define TXEN     3 // UART TX enable
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 100
;char rx_buffer[RX_BUFFER_SIZE];
;
;volatile static struct {u8 flag;    // Номер флага в флаговом байте
;                        u16 count;} // Выдержка
;                        Timer[4];// Очередь таймеров
;
;u8 text[11],get_phone[13],get_ready[6],buff[3],symb,iniflag = 1;
;u8 Numb = 4,sim900=0,ATflag=1,push, pin;
;bit state = 1,first = 1,fst=1,once_open=1,once_crash=1;
;//u8 OK[]="OK";  buffer[3],
;__eeprom u8 alarm = 0;
;__flash u8 my_phone[] = "+79098450953"; // - наш телефон;   +79842837204
;__flash u8 service[] = "+79037011111";  // телефон сервис-центра смс
;__flash u8 Ready[] = "Ready";           // успешная ини sim900
;__flash u8 start[] = "03";              // завести
;__flash u8 stop[] = "04";               // заглушить
;__flash u8 unlock[] = "02";             // разблок.
;__flash u8 lock[] = "01";               // заблок.
;__flash u8 open_door[] = "door_open";
;__flash u8 crash_door[] = "crash_sens";
;__flash u8 error_cmd[] = "error_cmd";
;__flash u8 car_lock[] = "car_lock";
;__flash u8 car_unlock[] = "car_unlock";
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void) {u8 i;
; 0000 0061 interrupt [9] void timer1_ovf_isr(void) {unsigned char     i;

	.CSEG
_timer1_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0062 for(i=0;i!=Numb;i++){     // Прочесываем очередь таймеров
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x4:
	CP   R7,R17
	BREQ _0x5
; 0000 0063   	 //if(Timer[i].flag == 0) continue; // Если нашли пустышку - следующая итерация
; 0000 0064 	 if(Timer[i].count !=0) {   // Если таймер не выщелкал, то щелкаем еще раз.
	RCALL SUBOPT_0x0
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x6
; 0000 0065         Timer[i].count --;	// Уменьшаем число в ячейке если не конец.
	RCALL SUBOPT_0x0
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0066       	                    }
; 0000 0067 
; 0000 0068    	 else {
	RJMP _0x7
_0x6:
; 0000 0069           Timer[i].flag = 0 ;   // Дощелкали до нуля? Сбрасываем флаг в флаговом байте
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_Timer_G000)
	SBCI R31,HIGH(-_Timer_G000)
	RCALL SUBOPT_0x1
; 0000 006A           if((Timer[0].flag == 0)&&(Timer[1].flag == 0)&&
; 0000 006B           (Timer[2].flag == 0)&&(Timer[3].flag == 0)) {TIMSK &= ~(1<<TOIE1);} // Timer1 off
	LDS  R26,_Timer_G000
	CPI  R26,LOW(0x0)
	BRNE _0x9
	__GETB2MN _Timer_G000,3
	CPI  R26,LOW(0x0)
	BRNE _0x9
	__GETB2MN _Timer_G000,6
	CPI  R26,LOW(0x0)
	BRNE _0x9
	__GETB2MN _Timer_G000,9
	CPI  R26,LOW(0x0)
	BREQ _0xA
_0x9:
	RJMP _0x8
_0xA:
	IN   R30,0x39
	ANDI R30,0xFB
	OUT  0x39,R30
; 0000 006C       	  }
_0x8:
_0x7:
; 0000 006D    	                }
	SUBI R17,-1
	RJMP _0x4
_0x5:
; 0000 006E  //TIMER1 has overflowed
; 0000 006F  TCNT1H = 0xFE; //setup
	RCALL SUBOPT_0x2
; 0000 0070  TCNT1L = 0x24;
; 0000 0071                                                }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void) {
; 0000 0073 interrupt [12] void usart_rx_isr(void) {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0074     char status, data;
; 0000 0075     status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0076     data=UDR;
	IN   R16,12
; 0000 0077     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xB
; 0000 0078         rx_buffer[rx_wr_index]=data;
	MOV  R30,R10
	RCALL SUBOPT_0x3
	ST   Z,R16
; 0000 0079         if (++rx_wr_index == RX_BUFFER_SIZE) {
	INC  R10
	LDI  R30,LOW(100)
	CP   R30,R10
	BRNE _0xC
; 0000 007A             rx_wr_index=0;
	CLR  R10
; 0000 007B                                              };
_0xC:
; 0000 007C         if (++rx_counter == RX_BUFFER_SIZE) {
	INC  R12
	LDI  R30,LOW(100)
	CP   R30,R12
	BRNE _0xD
; 0000 007D             rx_counter=0;
	CLR  R12
; 0000 007E             rx_buffer_overflow=1;
	SET
	BLD  R2,5
; 0000 007F                                             };
_0xD:
; 0000 0080                                                                      };
_0xB:
; 0000 0081                                               }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void){
; 0000 0087 char getchar(void){
_getchar:
; 0000 0088 char data;
; 0000 0089 if (rx_counter==0);
	ST   -Y,R17
;	data -> R17
; 0000 008A data=rx_buffer[rx_rd_index++];
	MOV  R30,R13
	INC  R13
	RCALL SUBOPT_0x3
	LD   R17,Z
; 0000 008B #if RX_BUFFER_SIZE != 256
; 0000 008C if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(100)
	CP   R30,R13
	BRNE _0xF
	CLR  R13
; 0000 008D #endif
; 0000 008E #asm("cli")
_0xF:
	cli
; 0000 008F --rx_counter;
	DEC  R12
; 0000 0090 #asm("sei")
	sei
; 0000 0091 return data;
	MOV  R30,R17
	RJMP _0x2060002
; 0000 0092                   }
;#pragma used-
;#endif
;// Declare your global variables here
;void ini_avr(void){
; 0000 0096 void ini_avr(void){
_ini_avr:
; 0000 0097 // Declare your local variables here
; 0000 0098 
; 0000 0099 // Input/Output Ports initialization
; 0000 009A // Port B initialization
; 0000 009B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009D PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 009E DDRB=0x02;
	LDI  R30,LOW(2)
	OUT  0x17,R30
; 0000 009F 
; 0000 00A0 // Port C initialization
; 0000 00A1 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A2 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A3 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00A4 DDRC=0x00;
	OUT  0x14,R30
; 0000 00A5 
; 0000 00A6 // Port D initialization
; 0000 00A7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A9 PORTD=0x00;
	OUT  0x12,R30
; 0000 00AA DDRD=0x00;
	OUT  0x11,R30
; 0000 00AB 
; 0000 00AC // Timer/Counter 0 initialization
; 0000 00AD // Clock source: System Clock
; 0000 00AE // Clock value: Timer 0 Stopped
; 0000 00AF TCCR0=0x00;
	OUT  0x33,R30
; 0000 00B0 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00B1 
; 0000 00B2 //TIMER1 initialize - prescale:8
; 0000 00B3 // WGM: 0) Normal, TOP=0xFFFF
; 0000 00B4 // desired value: 1000Hz
; 0000 00B5 // actual value: 1000,000Hz (0,0%)
; 0000 00B6  TCCR1B = 0x00; //stop
	OUT  0x2E,R30
; 0000 00B7  TCNT1H = 0xFE; //setup
	RCALL SUBOPT_0x2
; 0000 00B8  TCNT1L = 0x24;
; 0000 00B9  OCR1AH = 0x01;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
; 0000 00BA  OCR1AL = 0xDC;
	LDI  R30,LOW(220)
	OUT  0x2A,R30
; 0000 00BB  OCR1BH = 0x01;
	LDI  R30,LOW(1)
	OUT  0x29,R30
; 0000 00BC  OCR1BL = 0xDC;
	LDI  R30,LOW(220)
	OUT  0x28,R30
; 0000 00BD  ICR1H  = 0x01;
	LDI  R30,LOW(1)
	OUT  0x27,R30
; 0000 00BE  ICR1L  = 0xDC;
	LDI  R30,LOW(220)
	OUT  0x26,R30
; 0000 00BF  TCCR1A = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00C0  TCCR1B = 0x02; //start Timer
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 00C1 
; 0000 00C2 // Timer/Counter 2 initialization
; 0000 00C3 // Clock source: System Clock
; 0000 00C4 // Clock value: Timer2 Stopped
; 0000 00C5 // Mode: Normal top=0xFF
; 0000 00C6 // OC2 output: Disconnected
; 0000 00C7 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 00C8 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00C9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00CA OCR2=0x00;
	OUT  0x23,R30
; 0000 00CB 
; 0000 00CC // External Interrupt(s) initialization
; 0000 00CD // INT0: Off
; 0000 00CE // INT1: Off
; 0000 00CF MCUCR=0x00;
	OUT  0x35,R30
; 0000 00D0 
; 0000 00D1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D2 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00D3 
; 0000 00D4 // USART initialization
; 0000 00D5 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00D6 // USART Receiver: On
; 0000 00D7 // USART Transmitter: On
; 0000 00D8 // USART Mode: Asynchronous
; 0000 00D9 // USART Baud Rate: 19200
; 0000 00DA UCSRA=0x00;
	OUT  0xB,R30
; 0000 00DB UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00DC UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00DD UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00DE UBRRL=0x0C;   //19200 при xtal 4,0МГц
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 00DF //UBRRL=0x23; //19200 при xtal 11,0592МГц
; 0000 00E0 
; 0000 00E1 // Analog Comparator initialization
; 0000 00E2 // Analog Comparator: Off
; 0000 00E3 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00E4 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00E5 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00E6 
; 0000 00E7 // ADC initialization
; 0000 00E8 // ADC disabled
; 0000 00E9 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00EA 
; 0000 00EB // SPI initialization
; 0000 00EC // SPI disabled
; 0000 00ED SPCR=0x00;
	OUT  0xD,R30
; 0000 00EE 
; 0000 00EF // TWI initialization
; 0000 00F0 // TWI disabled
; 0000 00F1 TWCR=0x00;
	OUT  0x36,R30
; 0000 00F2 
; 0000 00F3 // Watchdog Timer Prescaler: OSC/2048k
; 0000 00F4 #pragma optsize-
; 0000 00F5 WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 00F6 WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 00F7 #ifdef _OPTIMIZE_SIZE_
; 0000 00F8 #pragma optsize+
; 0000 00F9 #endif
; 0000 00FA // Global enable interrupts
; 0000 00FB #asm("sei")
	sei
; 0000 00FC }
	RET
;
;void soft_delay(u16 ms, u8 i){
; 0000 00FE void soft_delay(unsigned int     ms, unsigned char     i){
_soft_delay:
; 0000 00FF        Timer[i].count = ms;     // s
;	ms -> Y+1
;	i -> Y+0
	RCALL SUBOPT_0x4
	__ADDW1MN _Timer_G000,1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0100        Timer[i].flag = 1;
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_Timer_G000)
	SBCI R31,HIGH(-_Timer_G000)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 0101        TIMSK |= 1 << TOIE1;     // Timer1 on
	IN   R30,0x39
	ORI  R30,4
	OUT  0x39,R30
; 0000 0102                              }
	RJMP _0x2060001
;
;void clean_rx_buff(void){ u8 i;// очистка буфера массива символов
; 0000 0104 void clean_rx_buff(void){ unsigned char     i;
_clean_rx_buff:
; 0000 0105                   for (i=0;i<RX_BUFFER_SIZE;i++){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x11:
	CPI  R17,100
	BRSH _0x12
; 0000 0106                        rx_buffer[i] = '\0';      // <NULL>
	MOV  R30,R17
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1
; 0000 0107                                                 }
	SUBI R17,-1
	RJMP _0x11
_0x12:
; 0000 0108                         }
	RJMP _0x2060002
;
;void clean_get_phone(void){ u8 i;// очистка буфера принятого номера
; 0000 010A void clean_get_phone(void){ unsigned char     i;
_clean_get_phone:
; 0000 010B                   for (i=0;i<13;i++){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x14:
	CPI  R17,13
	BRSH _0x15
; 0000 010C                        get_phone[i] = '\0';      // <NULL>
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_get_phone)
	SBCI R31,HIGH(-_get_phone)
	RCALL SUBOPT_0x1
; 0000 010D                                                 }
	SUBI R17,-1
	RJMP _0x14
_0x15:
; 0000 010E                           }
	RJMP _0x2060002
;
;void clean(void){      // очистка смс буфера
; 0000 0110 void clean(void){
_clean:
; 0000 0111      clean_rx_buff();  // очистка буфера приёма
	RCALL _clean_rx_buff
; 0000 0112      buff[0] = '\0';   // <NULL>  первая цифра в смс
	LDI  R30,LOW(0)
	STS  _buff,R30
; 0000 0113      buff[1] = '\0';   // <NULL>  вторая цифра в смс
	__PUTB1MN _buff,1
; 0000 0114      sim900 = 2;       // шаг ини
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 0115      ATflag = 10;      // удаляем смс
	LDI  R30,LOW(10)
	MOV  R9,R30
; 0000 0116      iniflag = 1;      // взводим ини SIM900
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0117      first = 1;        // первый вход в ATflag == 10
	RCALL SUBOPT_0x6
; 0000 0118      fst = 1;
	SET
	BLD  R2,2
; 0000 0119      soft_delay(500,1);// время для обработки ATflag == 10
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 011A                 }
	RET
;
;void chek_get (void){
; 0000 011C void chek_get (void){
_chek_get:
; 0000 011D             if(getchar() == 'O'){       // ждем O
	RCALL _getchar
	CPI  R30,LOW(0x4F)
	BRNE _0x16
; 0000 011E                if(getchar() == 'K'){    // и проверяем подтверждение
	RCALL _getchar
	CPI  R30,LOW(0x4B)
	BRNE _0x17
; 0000 011F                   ATflag++;
	INC  R9
; 0000 0120                   clean_rx_buff();      // очистка буфера
	RCALL _clean_rx_buff
; 0000 0121                                    }
; 0000 0122                first = 1;               // повторить команду
_0x17:
	RCALL SUBOPT_0x6
; 0000 0123                clean_rx_buff();
	RCALL _clean_rx_buff
; 0000 0124                                 }
; 0000 0125                     }
_0x16:
	RET
;
;void SGPIO (u8 operation_r_w, u8 GPIO_pin, u8 function_in_out, u8 level){
; 0000 0127 void SGPIO (unsigned char     operation_r_w, unsigned char     GPIO_pin, unsigned char     function_in_out, unsigned char     level){
_SGPIO:
; 0000 0128   printf("AT+SGPIO=%d,%d,%d,%d\r\n",operation_r_w,GPIO_pin,function_in_out,level); // конфиг.вх/вых.
;	operation_r_w -> Y+3
;	GPIO_pin -> Y+2
;	function_in_out -> Y+1
;	level -> Y+0
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x9
	LDD  R30,Y+5
	RCALL SUBOPT_0xA
	LDD  R30,Y+8
	RCALL SUBOPT_0xA
	LDD  R30,Y+11
	RCALL SUBOPT_0xA
	LDD  R30,Y+14
	RCALL SUBOPT_0xA
	LDI  R24,16
	RCALL _printf
	ADIW R28,18
; 0000 0129   clean_rx_buff();  // очистка буфера
	RCALL _clean_rx_buff
; 0000 012A                                                                         }
	ADIW R28,4
	RET
;
;void sms(void){
; 0000 012C void sms(void){
_sms:
; 0000 012D          if(fst == 1) {         // первый вход
	SBRS R2,2
	RJMP _0x18
; 0000 012E             printf("AT+CMGS="); // set sms
	__POINTW1FN _0x0,23
	RCALL SUBOPT_0xB
; 0000 012F             putchar('"');
; 0000 0130             printf(my_phone);   // телефон
	LDI  R30,LOW(_my_phone*2)
	LDI  R31,HIGH(_my_phone*2)
	RCALL SUBOPT_0xB
; 0000 0131             putchar('"');
; 0000 0132             printf("\r\n");     // CR LF
	RCALL SUBOPT_0xC
; 0000 0133             soft_delay(500,0);  // delay 500ms
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xD
; 0000 0134             soft_delay(5000,1); // delay 5s
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x8
; 0000 0135             fst = 0;            // больше не повторять
	CLT
	BLD  R2,2
; 0000 0136                        }
; 0000 0137          if (Timer[0].flag == 0) {
_0x18:
	RCALL SUBOPT_0xE
	BRNE _0x19
; 0000 0138             //if(getchar() == '>'){   // ожидаем
; 0000 0139                puts(text);          // send err
	LDI  R30,LOW(_text)
	LDI  R31,HIGH(_text)
	RCALL SUBOPT_0x9
	RCALL _puts
; 0000 013A                putsf("\x1A\x0D");   // SUB (CTRL + Z)
	__POINTW1FN _0x0,32
	RCALL SUBOPT_0xF
; 0000 013B                if(sim900 == 7) {sim900++;}  // след.шаг
	LDI  R30,LOW(7)
	CP   R30,R6
	BRNE _0x1A
	INC  R6
; 0000 013C                else {pin = cln;}    // след.шаг
	RJMP _0x1B
_0x1A:
	LDI  R30,LOW(3)
	MOV  R11,R30
_0x1B:
; 0000 013D                                 //}
; 0000 013E                                  }
; 0000 013F          if (Timer[1].flag == 0) {
_0x19:
	RCALL SUBOPT_0x10
	BRNE _0x1C
; 0000 0140              clean();               // очистка смс буфера
	RCALL _clean
; 0000 0141                                  }
; 0000 0142               }
_0x1C:
	RET
;
;void ini_sim900(void){u8 t = 20;   //ms
; 0000 0144 void ini_sim900(void){unsigned char     t = 20;
_ini_sim900:
; 0000 0145 switch (ATflag) {
	ST   -Y,R17
;	t -> R17
	LDI  R17,20
	MOV  R30,R9
	RCALL SUBOPT_0x11
; 0000 0146 case 1: {
	RCALL SUBOPT_0x12
	BRNE _0x20
; 0000 0147          if(first){                // первый вход
	SBRS R2,1
	RJMP _0x21
; 0000 0148          putsf("AT+IPR=19200\r");  // set Baud Rate sim900
	__POINTW1FN _0x0,35
	RCALL SUBOPT_0xF
; 0000 0149          soft_delay(t,0); // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 014A          first = 0;
	RCALL SUBOPT_0x14
; 0000 014B                   }
; 0000 014C 
; 0000 014D          if(Timer[0].flag == 0) {
_0x21:
	RCALL SUBOPT_0xE
	BRNE _0x22
; 0000 014E          //ATflag++;
; 0000 014F          chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 0150                                 }
; 0000 0151         }
_0x22:
; 0000 0152 break;
	RJMP _0x1F
; 0000 0153 case 2: {
_0x20:
	RCALL SUBOPT_0x15
	BRNE _0x23
; 0000 0154          if(first){         // первый вход
	SBRS R2,1
	RJMP _0x24
; 0000 0155          putsf("ATE0\r");   // stop echo
	__POINTW1FN _0x0,49
	RCALL SUBOPT_0xF
; 0000 0156          soft_delay(t,0);  // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 0157          first = 0;
	RCALL SUBOPT_0x14
; 0000 0158                   }
; 0000 0159          if (Timer[0].flag == 0) {
_0x24:
	RCALL SUBOPT_0xE
	BRNE _0x25
; 0000 015A              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 015B                                  }
; 0000 015C         }
_0x25:
; 0000 015D break;
	RJMP _0x1F
; 0000 015E case 3: {
_0x23:
	RCALL SUBOPT_0x16
	BRNE _0x26
; 0000 015F          if(first){         // первый вход
	SBRS R2,1
	RJMP _0x27
; 0000 0160          putsf("ATV1\r");   // OK echo
	__POINTW1FN _0x0,55
	RCALL SUBOPT_0xF
; 0000 0161          soft_delay(t,0);   // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 0162          first = 0;
	RCALL SUBOPT_0x14
; 0000 0163                   }
; 0000 0164          if (Timer[0].flag == 0) {
_0x27:
	RCALL SUBOPT_0xE
	BRNE _0x28
; 0000 0165              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 0166                                  }
; 0000 0167         }
_0x28:
; 0000 0168 break;
	RJMP _0x1F
; 0000 0169 case 4: {
_0x26:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x29
; 0000 016A          if(first){            // первый вход
	SBRS R2,1
	RJMP _0x2A
; 0000 016B          putsf("AT+CMEE=0\r"); // stop error code
	__POINTW1FN _0x0,61
	RCALL SUBOPT_0xF
; 0000 016C          soft_delay(t,0);      // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 016D          first = 0;
	RCALL SUBOPT_0x14
; 0000 016E                   }
; 0000 016F          if (Timer[0].flag == 0) {
_0x2A:
	RCALL SUBOPT_0xE
	BRNE _0x2B
; 0000 0170              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 0171                                  }
; 0000 0172         }
_0x2B:
; 0000 0173 break;
	RJMP _0x1F
; 0000 0174 case 5: {
_0x29:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2C
; 0000 0175          if(first){            // первый вход
	SBRS R2,1
	RJMP _0x2D
; 0000 0176          putsf("AT+CLIP=1\r"); // АОН enable
	__POINTW1FN _0x0,72
	RCALL SUBOPT_0xF
; 0000 0177          soft_delay(t,0);      // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 0178          first = 0;
	RCALL SUBOPT_0x14
; 0000 0179                   }
; 0000 017A          if (Timer[0].flag == 0) {
_0x2D:
	RCALL SUBOPT_0xE
	BRNE _0x2E
; 0000 017B              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 017C                                  }
; 0000 017D         }
_0x2E:
; 0000 017E break;
	RJMP _0x1F
; 0000 017F case 6: {
_0x2C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2F
; 0000 0180          if(first){          // первый вход
	SBRS R2,1
	RJMP _0x30
; 0000 0181          printf("AT+CSCA="); // set sms-service number
	__POINTW1FN _0x0,83
	RCALL SUBOPT_0xB
; 0000 0182          putchar('"');
; 0000 0183          printf(service);    // телефон сервис-центра смс
	LDI  R30,LOW(_service*2)
	LDI  R31,HIGH(_service*2)
	RCALL SUBOPT_0xB
; 0000 0184          putchar('"');
; 0000 0185          printf("\r\n");
	RCALL SUBOPT_0xC
; 0000 0186          soft_delay(t,0);    // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 0187          first = 0;
	RCALL SUBOPT_0x14
; 0000 0188                   }
; 0000 0189          if (Timer[0].flag == 0) {
_0x30:
	RCALL SUBOPT_0xE
	BRNE _0x31
; 0000 018A              chek_get ();    // проверяем ответ sim900
	RCALL _chek_get
; 0000 018B                                  }
; 0000 018C         }
_0x31:
; 0000 018D break;
	RJMP _0x1F
; 0000 018E case 7: {
_0x2F:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x32
; 0000 018F          if(first){            // первый вход
	SBRS R2,1
	RJMP _0x33
; 0000 0190          putsf("AT+CSCB=1\r"); // stop Cell Broadcast
	__POINTW1FN _0x0,92
	RCALL SUBOPT_0xF
; 0000 0191          soft_delay(t,0);      // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 0192          first = 0;
	RCALL SUBOPT_0x14
; 0000 0193                   }
; 0000 0194          if (Timer[0].flag == 0) {
_0x33:
	RCALL SUBOPT_0xE
	BRNE _0x34
; 0000 0195              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 0196                                  }
; 0000 0197         }
_0x34:
; 0000 0198 break;
	RJMP _0x1F
; 0000 0199 case 8: {
_0x32:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x35
; 0000 019A          if(first){            // первый вход
	SBRS R2,1
	RJMP _0x36
; 0000 019B          putsf("AT+CMGF=1\r"); // text format sms
	__POINTW1FN _0x0,103
	RCALL SUBOPT_0xF
; 0000 019C          soft_delay(t,0);      // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 019D          first = 0;
	RCALL SUBOPT_0x14
; 0000 019E                   }
; 0000 019F          if (Timer[0].flag == 0) {
_0x36:
	RCALL SUBOPT_0xE
	BRNE _0x37
; 0000 01A0              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 01A1                                  }
; 0000 01A2         }
_0x37:
; 0000 01A3 break;
	RJMP _0x1F
; 0000 01A4 case 9: {
_0x35:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x38
; 0000 01A5          if(first){         // первый вход
	SBRS R2,1
	RJMP _0x39
; 0000 01A6          printf("AT+CSCS="); // тип сети
	__POINTW1FN _0x0,114
	RCALL SUBOPT_0xB
; 0000 01A7          putchar('"');
; 0000 01A8          printf("GSM");
	__POINTW1FN _0x0,123
	RCALL SUBOPT_0xB
; 0000 01A9          putchar('"');
; 0000 01AA          printf("\r\n");
	RCALL SUBOPT_0xC
; 0000 01AB          soft_delay(t,0);    // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 01AC          first = 0;
	RCALL SUBOPT_0x14
; 0000 01AD                   }
; 0000 01AE          if (Timer[0].flag == 0) {
_0x39:
	RCALL SUBOPT_0xE
	BRNE _0x3A
; 0000 01AF              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 01B0                                  }
; 0000 01B1         }
_0x3A:
; 0000 01B2 break;
	RJMP _0x1F
; 0000 01B3 case 10: {
_0x38:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x3E
; 0000 01B4          if(first){           // первый вход
	SBRS R2,1
	RJMP _0x3C
; 0000 01B5          printf("AT+CMGDA="); // удаление всех смс
	__POINTW1FN _0x0,127
	RCALL SUBOPT_0xB
; 0000 01B6          putchar('"');
; 0000 01B7          printf("DEL ALL");
	__POINTW1FN _0x0,137
	RCALL SUBOPT_0xB
; 0000 01B8          putchar('"');
; 0000 01B9          printf("\r\n");
	RCALL SUBOPT_0xC
; 0000 01BA          soft_delay(t,0);    // delay 10ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x13
; 0000 01BB          first = 0;
	RCALL SUBOPT_0x14
; 0000 01BC                   }
; 0000 01BD          if (Timer[0].flag == 0) {
_0x3C:
	RCALL SUBOPT_0xE
	BRNE _0x3D
; 0000 01BE              chek_get (); // проверяем ответ sim900
	RCALL _chek_get
; 0000 01BF                                  }
; 0000 01C0          }
_0x3D:
; 0000 01C1 break;
	RJMP _0x1F
; 0000 01C2 
; 0000 01C3 default: {iniflag = 0; // ini_ok
_0x3E:
	CLR  R4
; 0000 01C4           ATflag = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 01C5          }
; 0000 01C6               }
_0x1F:
; 0000 01C7                      }
_0x2060002:
	LD   R17,Y+
	RET
;
;void pwrkey_change (u8 i, u16 ms){
; 0000 01C9 void pwrkey_change (unsigned char     i, unsigned int     ms){
_pwrkey_change:
; 0000 01CA      pwrkey = i;       // действие на кнопку reset: 1 - вкл.; 0 - выкл.
;	i -> Y+2
;	ms -> Y+0
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x3F
	CBI  0x18,1
	RJMP _0x40
_0x3F:
	SBI  0x18,1
_0x40:
; 0000 01CB      soft_delay(ms,2); // delay мs 2й таймер
	LD   R30,Y
	LDD  R31,Y+1
	RCALL SUBOPT_0x17
; 0000 01CC                                  }
	RJMP _0x2060001
;
;void key_repit(void){
; 0000 01CE void key_repit(void){
_key_repit:
; 0000 01CF      if(first){
	SBRS R2,1
	RJMP _0x41
; 0000 01D0         pwrkey_change(1,1200); // вкл.кнопку на 1200мс
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 01D1         first = 0;
	RCALL SUBOPT_0x14
; 0000 01D2               }
; 0000 01D3      if(Timer[2].flag == 0){
_0x41:
	RCALL SUBOPT_0x1A
	BRNE _0x42
; 0000 01D4         pwrkey_change(0,2000); // выкл.кнопку на 2000мс
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0x9
	RCALL _pwrkey_change
; 0000 01D5         first = 1;             // первый вход в ATflag == 10
	RCALL SUBOPT_0x6
; 0000 01D6         push++;                // след.нажатие
	INC  R8
; 0000 01D7                            }
; 0000 01D8               }
_0x42:
	RET
;
;void main(void){
; 0000 01DA void main(void){
_main:
; 0000 01DB ini_avr();
	RCALL _ini_avr
; 0000 01DC 
; 0000 01DD while (1){
_0x43:
; 0000 01DE #asm("wdr")
	wdr
; 0000 01DF if (status_SIM) { // если sim900 включен:
	SBIS 0x16,0
	RJMP _0x46
; 0000 01E0 switch (sim900){  // автомат инициализации модуля и приёма смс
	MOV  R30,R6
	RCALL SUBOPT_0x11
; 0000 01E1 case 0:{
	SBIW R30,0
	BRNE _0x4A
; 0000 01E2         if (first){
	SBRS R2,1
	RJMP _0x4B
; 0000 01E3         soft_delay(15000,1);     // delay 10s softtim №1
	LDI  R30,LOW(15000)
	LDI  R31,HIGH(15000)
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x8
; 0000 01E4         first = 0;
	RCALL SUBOPT_0x14
; 0000 01E5                   }
; 0000 01E6         if(getchar() == 'l'){    // ЖДЕМ l
_0x4B:
	RCALL _getchar
	CPI  R30,LOW(0x6C)
	BRNE _0x4C
; 0000 01E7         symb = rx_rd_index;      // записываем индекс l
	RCALL SUBOPT_0x1C
; 0000 01E8         soft_delay(20,0);        // delay 20ms
; 0000 01E9         sim900 = 1;              // след.шаг
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 01EA         first = 1;
	RCALL SUBOPT_0x6
; 0000 01EB                             }
; 0000 01EC         if(Timer[1].flag == 0){  // ждем пока SIM900 загрузится
_0x4C:
	RCALL SUBOPT_0x10
	BRNE _0x4D
; 0000 01ED         sim900 = 100;            // если не успел, то перезагр.
	LDI  R30,LOW(100)
	MOV  R6,R30
; 0000 01EE         first = 1;
	RCALL SUBOPT_0x6
; 0000 01EF                               }
; 0000 01F0        }
_0x4D:
; 0000 01F1 break;
	RJMP _0x49
; 0000 01F2 case 1:{
_0x4A:
	RCALL SUBOPT_0x12
	BRNE _0x4E
; 0000 01F3    if (Timer[0].flag == 0){
	RCALL SUBOPT_0xE
	BRNE _0x4F
; 0000 01F4        rx_rd_index = symb+2;   // восстанавливаем индекс l; call ready
	MOV  R30,R5
	SUBI R30,-LOW(2)
	MOV  R13,R30
; 0000 01F5        gets(get_ready, 5);     // заполняем буфер
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL _gets
; 0000 01F6        if(memcmpf (get_ready, Ready, 5) == 0){ // и сравниваем его с нашим телефоном
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	BRNE _0x50
; 0000 01F7           clean_rx_buff();     // очистка буфера
	RCALL _clean_rx_buff
; 0000 01F8           soft_delay(2000,1);  // delay 2s softtim №1
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x8
; 0000 01F9           sim900 = 2;          // след.шаг
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 01FA                                              }
; 0000 01FB        if(memcmpf (get_ready, Ready, 5) != 0){ // если не готов за 10с + 20мс
_0x50:
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	BREQ _0x51
; 0000 01FC           clean_rx_buff();     // очистка буфера
	RCALL _clean_rx_buff
; 0000 01FD           sim900 = 100;        // перезагрузка sim900
	LDI  R30,LOW(100)
	MOV  R6,R30
; 0000 01FE                                              }
; 0000 01FF                           }
_0x51:
; 0000 0200        }
_0x4F:
; 0000 0201 break;
	RJMP _0x49
; 0000 0202 case 2:{
_0x4E:
	RCALL SUBOPT_0x15
	BRNE _0x52
; 0000 0203         ini_sim900();       // переход к автомату инициализации sim900
	RCALL _ini_sim900
; 0000 0204         if((Timer[1].flag == 0)&&(iniflag == 1)){ // если за 9сек. не инициализирован
	__GETB2MN _Timer_G000,3
	CPI  R26,LOW(0x0)
	BRNE _0x54
	LDI  R30,LOW(1)
	CP   R30,R4
	BREQ _0x55
_0x54:
	RJMP _0x53
_0x55:
; 0000 0205             sim900 = 100;                         // перезагрузка sim900
	LDI  R30,LOW(100)
	MOV  R6,R30
; 0000 0206             first = 1;                            // первый вход в перезагрузку
	RCALL SUBOPT_0x6
; 0000 0207                                                 }
; 0000 0208         if(iniflag == 0){                         // инициализирован
_0x53:
	TST  R4
	BRNE _0x56
; 0000 0209             sim900 = 3;                           // след.шаг
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 020A                         }
; 0000 020B        }
_0x56:
; 0000 020C break;
	RJMP _0x49
; 0000 020D case 3:{
_0x52:
	RCALL SUBOPT_0x16
	BRNE _0x57
; 0000 020E if(getchar() == '"'){       // ЖДЕМ КАВЫЧКУ (0x22)
	RCALL _getchar
	CPI  R30,LOW(0x22)
	BRNE _0x58
; 0000 020F    symb = --rx_rd_index;    // записываем индекс кавычки
	DEC  R13
	RCALL SUBOPT_0x1C
; 0000 0210    soft_delay(20,0);        // delay 20ms
; 0000 0211    sim900 = 4;              // след.шаг
	LDI  R30,LOW(4)
	MOV  R6,R30
; 0000 0212                     }
; 0000 0213        }
_0x58:
; 0000 0214 break;
	RJMP _0x49
; 0000 0215 case 4:{
_0x57:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x59
; 0000 0216    if (Timer[0].flag == 0){
	RCALL SUBOPT_0xE
	BRNE _0x5A
; 0000 0217        rx_rd_index = ++symb;   // восстанавливаем индекс кавычки
	INC  R5
	MOV  R13,R5
; 0000 0218        gets(get_phone, 12);    // заполняем буфер
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	RCALL _gets
; 0000 0219        if(memcmpf (get_phone, my_phone, 12) == 0) { // и сравниваем его с нашим телефоном
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x20
	BRNE _0x5B
; 0000 021A           sim900 = 5;          // след.шаг
	LDI  R30,LOW(5)
	MOV  R6,R30
; 0000 021B           clean_get_phone();      // очистка буфера
	RCALL _clean_get_phone
; 0000 021C           rx_buffer[symb] = '\0'; // <NULL> удаляем кавычку
	MOV  R30,R5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x1
; 0000 021D           soft_delay(20,0);       // delay 20ms
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x13
; 0000 021E                                                   }
; 0000 021F        if(memcmpf (get_phone, my_phone, 12) == 1) { // если не мой телефон пришел за 20мс
_0x5B:
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x23
	RCALL _memcmpf
	CPI  R30,LOW(0x1)
	BRNE _0x5C
; 0000 0220           clean_rx_buff();      // очистка буфера
	RCALL _clean_rx_buff
; 0000 0221           clean_get_phone();    // очистка буфера
	RCALL _clean_get_phone
; 0000 0222           sim900 = 3;           // пред.шаг
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 0223                                                   }
; 0000 0224                           }
_0x5C:
; 0000 0225        }
_0x5A:
; 0000 0226 break;
	RJMP _0x49
; 0000 0227 case 5:{
_0x59:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0228 if (getchar() == '\n') {       // ожидаем LF (0x0A)
	RCALL _getchar
	CPI  R30,LOW(0xA)
	BRNE _0x5E
; 0000 0229     symb = --rx_rd_index;      // записываем индекс LF
	DEC  R13
	MOV  R5,R13
; 0000 022A     soft_delay(10,0);          // delay 10ms
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x13
; 0000 022B     sim900 = 6;                // след.шаг
	LDI  R30,LOW(6)
	MOV  R6,R30
; 0000 022C                        }
; 0000 022D if (Timer[0].flag == 0) {      // если за 20мс не пришел конец строки
_0x5E:
	RCALL SUBOPT_0xE
	BRNE _0x5F
; 0000 022E     clean_rx_buff();           // очистка буфера
	RCALL _clean_rx_buff
; 0000 022F     sim900 = 3;                // пред.шаг
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 0230                         }
; 0000 0231        }
_0x5F:
; 0000 0232 break;
	RJMP _0x49
; 0000 0233 case 6:{
_0x5D:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x60
; 0000 0234    if(Timer[0].flag == 0) { u8 i;
	RCALL SUBOPT_0xE
	BREQ PC+2
	RJMP _0x61
; 0000 0235      rx_rd_index = ++symb;             // восстанавливаем индекс c LF
	SBIW R28,1
;	i -> Y+0
	INC  R5
	MOV  R13,R5
; 0000 0236      gets(buff, 2);                    // заполняем буфер
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL _gets
; 0000 0237      if(memcmpf (buff, start, 2) == 0){// если смс == 03
	RCALL SUBOPT_0x24
	LDI  R30,LOW(_start*2)
	LDI  R31,HIGH(_start*2)
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x20
	BRNE _0x62
; 0000 0238          SGPIO(write,pin_1,out,high);  // 1й пин конфиг. на вых. и вкл.
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL _SGPIO
; 0000 0239          clean();                      // очистка смс буфера
	RCALL _clean
; 0000 023A                                       }
; 0000 023B      else if(memcmpf (buff, stop, 2) == 0){   // если смс == 04
	RJMP _0x63
_0x62:
	RCALL SUBOPT_0x24
	LDI  R30,LOW(_stop*2)
	LDI  R31,HIGH(_stop*2)
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x20
	BRNE _0x64
; 0000 023C          SGPIO(write,pin_1,out,low);   // 1й пин конфиг. на вых. и выкл.
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1B
	RCALL _SGPIO
; 0000 023D          clean();                      // очистка смс буфера
	RCALL _clean
; 0000 023E                                           }
; 0000 023F      else if(memcmpf (buff, unlock, 2) == 0){ // если смс == 02
	RJMP _0x65
_0x64:
	RCALL SUBOPT_0x24
	LDI  R30,LOW(_unlock*2)
	LDI  R31,HIGH(_unlock*2)
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x20
	BRNE _0x66
; 0000 0240            alarm = 0;                  // разблок.сигн.
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 0241            for (i=0;i<11;i++){
	RCALL SUBOPT_0x27
_0x68:
	RCALL SUBOPT_0x28
	BRSH _0x69
; 0000 0242              text[i] = car_unlock[i];  // записать текст смс
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_car_unlock*2)
	SBCI R31,HIGH(-_car_unlock*2)
	RCALL SUBOPT_0x2A
; 0000 0243                              }
	RCALL SUBOPT_0x2B
	RJMP _0x68
_0x69:
; 0000 0244            sim900 = 7;                 // отправитьс смс
	RJMP _0x9F
; 0000 0245                                             }
; 0000 0246      else if(memcmpf (buff, lock, 2) == 0){ // если смс == 01
_0x66:
	RCALL SUBOPT_0x24
	LDI  R30,LOW(_lock*2)
	LDI  R31,HIGH(_lock*2)
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x20
	BRNE _0x6B
; 0000 0247            alarm = 1;                  // заблок.сигн.
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 0248            for (i=0;i<11;i++){
	RCALL SUBOPT_0x27
_0x6D:
	RCALL SUBOPT_0x28
	BRSH _0x6E
; 0000 0249              text[i] = car_lock[i];    // записать текст смс
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_car_lock*2)
	SBCI R31,HIGH(-_car_lock*2)
	RCALL SUBOPT_0x2A
; 0000 024A                              }
	RCALL SUBOPT_0x2B
	RJMP _0x6D
_0x6E:
; 0000 024B            sim900 = 7;                 // отправитьс смс
	RJMP _0x9F
; 0000 024C                                           }
; 0000 024D      else {
_0x6B:
; 0000 024E            for (i=0;i<11;i++){
	RCALL SUBOPT_0x27
_0x71:
	RCALL SUBOPT_0x28
	BRSH _0x72
; 0000 024F              text[i] = error_cmd[i];   // записать текст смс
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_error_cmd*2)
	SBCI R31,HIGH(-_error_cmd*2)
	RCALL SUBOPT_0x2A
; 0000 0250                              }
	RCALL SUBOPT_0x2B
	RJMP _0x71
_0x72:
; 0000 0251            sim900 = 7;                 // отправитьс смс
_0x9F:
	LDI  R30,LOW(7)
	MOV  R6,R30
; 0000 0252           }
_0x65:
_0x63:
; 0000 0253      clean_rx_buff();                  // очистка буфера приёма
	RCALL _clean_rx_buff
; 0000 0254                           }
	ADIW R28,1
; 0000 0255        }
_0x61:
; 0000 0256 break;
	RJMP _0x49
; 0000 0257 case 7:{
_0x60:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x73
; 0000 0258         sms();                         // отправить смс
	RCALL _sms
; 0000 0259        }
; 0000 025A break;
	RJMP _0x49
; 0000 025B case 8:{
_0x73:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x49
; 0000 025C          if (Timer[1].flag == 0) {
	RCALL SUBOPT_0x10
	BRNE _0x75
; 0000 025D              clean();               // очистка смс буфера
	RCALL _clean
; 0000 025E                                  }
; 0000 025F        }
_0x75:
; 0000 0260 break;
; 0000 0261                }
_0x49:
; 0000 0262                 }
; 0000 0263 
; 0000 0264 if ((status_SIM) && (iniflag == 0) && (sim900 != 7) && (alarm == 1)){ u8 i; // опрос входов датчиков
_0x46:
	SBIS 0x16,0
	RJMP _0x77
	LDI  R30,LOW(0)
	CP   R30,R4
	BRNE _0x77
	LDI  R30,LOW(7)
	CP   R30,R6
	BREQ _0x77
	LDI  R26,LOW(_alarm)
	LDI  R27,HIGH(_alarm)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BREQ _0x78
_0x77:
	RJMP _0x76
_0x78:
; 0000 0265 //SGPIO(read,pin_1,0,0); // считать
; 0000 0266 switch (pin) {
	SBIW R28,1
;	i -> Y+0
	MOV  R30,R11
	RCALL SUBOPT_0x11
; 0000 0267 case check: {
	SBIW R30,0
	BRNE _0x7C
; 0000 0268    if (Timer[2].flag == 0) {
	RCALL SUBOPT_0x1A
	BRNE _0x7D
; 0000 0269              once_open = 1;                 // вкл.контроль дверей
	SET
	BLD  R2,3
; 0000 026A                            }
; 0000 026B    if (Timer[3].flag == 0) {
_0x7D:
	__GETB1MN _Timer_G000,9
	CPI  R30,0
	BRNE _0x7E
; 0000 026C              once_crash = 1;                // вкл.контроль датч.удара
	SET
	BLD  R2,4
; 0000 026D                            }
; 0000 026E    if (PINB.2 && once_open) {pin = open;    // дверь открыта
_0x7E:
	SBIS 0x16,2
	RJMP _0x80
	SBRC R2,3
	RJMP _0x81
_0x80:
	RJMP _0x7F
_0x81:
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 026F                 once_open = 0;              // выкл.контроль
	CLT
	BLD  R2,3
; 0000 0270                 for (i=0;i<11;i++){
	RCALL SUBOPT_0x27
_0x83:
	RCALL SUBOPT_0x28
	BRSH _0x84
; 0000 0271                 text[i] = open_door[i];     // записать текст смс
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_open_door*2)
	SBCI R31,HIGH(-_open_door*2)
	RCALL SUBOPT_0x2A
; 0000 0272                                   }
	RCALL SUBOPT_0x2B
	RJMP _0x83
_0x84:
; 0000 0273                 soft_delay(60000,2);        // delay 60s
	LDI  R30,LOW(60000)
	LDI  R31,HIGH(60000)
	RCALL SUBOPT_0x17
; 0000 0274                             }
; 0000 0275    if (PINB.3 && once_crash) {pin = crash;  // датчик удара
_0x7F:
	SBIS 0x16,3
	RJMP _0x86
	SBRC R2,4
	RJMP _0x87
_0x86:
	RJMP _0x85
_0x87:
	LDI  R30,LOW(2)
	MOV  R11,R30
; 0000 0276                 once_crash = 0;             // выкл.контроль
	CLT
	BLD  R2,4
; 0000 0277                 for (i=0;i<11;i++){
	RCALL SUBOPT_0x27
_0x89:
	RCALL SUBOPT_0x28
	BRSH _0x8A
; 0000 0278                 text[i] = crash_door[i];    // записать текст смс
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_crash_door*2)
	SBCI R31,HIGH(-_crash_door*2)
	RCALL SUBOPT_0x2A
; 0000 0279                                   }
	RCALL SUBOPT_0x2B
	RJMP _0x89
_0x8A:
; 0000 027A                 soft_delay(60000,3);        // delay 60s
	LDI  R30,LOW(60000)
	LDI  R31,HIGH(60000)
	RCALL SUBOPT_0x9
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _soft_delay
; 0000 027B                              }
; 0000 027C                     }
_0x85:
; 0000 027D break;
	RJMP _0x7B
; 0000 027E case open: {
_0x7C:
	RCALL SUBOPT_0x12
	BRNE _0x8B
; 0000 027F             sms();                          // отправить смс
	RCALL _sms
; 0000 0280            }
; 0000 0281 break;
	RJMP _0x7B
; 0000 0282 case crash: {
_0x8B:
	RCALL SUBOPT_0x15
	BRNE _0x8C
; 0000 0283              sms();                         // отправить смс
	RCALL _sms
; 0000 0284             }
; 0000 0285 break;
	RJMP _0x7B
; 0000 0286 case cln: {
_0x8C:
	RCALL SUBOPT_0x16
	BRNE _0x7B
; 0000 0287            if (Timer[1].flag == 0) {
	RCALL SUBOPT_0x10
	BRNE _0x8E
; 0000 0288            clean();     // очистка смс буфера
	RCALL _clean
; 0000 0289            pin = check; // на первый шаг
	CLR  R11
; 0000 028A                                    }
; 0000 028B           }
_0x8E:
; 0000 028C break;
; 0000 028D              }
_0x7B:
; 0000 028E                                                                     }
	ADIW R28,1
; 0000 028F 
; 0000 0290 if ((!status_SIM) && (sim900 != 100) && (state)){ // включение, если нет статуса pwr
_0x76:
	SBIC 0x16,0
	RJMP _0x90
	LDI  R30,LOW(100)
	CP   R30,R6
	BREQ _0x90
	SBRC R2,0
	RJMP _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 0291       iniflag = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0292       sim900 = 0;
	CLR  R6
; 0000 0293       clean_rx_buff();
	RCALL _clean_rx_buff
; 0000 0294       pwrkey_change(1,1200); // вкл.кнопку на 1200мс
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 0295       state =0;
	CLT
	BLD  R2,0
; 0000 0296                                                 }
; 0000 0297 
; 0000 0298 if ((sim900 != 100) && (Timer[2].flag == 0) && (state ==0)){ // завершить первое включение
_0x8F:
	LDI  R30,LOW(100)
	CP   R30,R6
	BREQ _0x93
	__GETB2MN _Timer_G000,6
	CPI  R26,LOW(0x0)
	BRNE _0x93
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x94
_0x93:
	RJMP _0x92
_0x94:
; 0000 0299      pwrkey_change(0,900);   // выкл.кнопку
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0x9
	RCALL _pwrkey_change
; 0000 029A      state = 1;
	SET
	BLD  R2,0
; 0000 029B                                                            }
; 0000 029C 
; 0000 029D if (sim900 == 100) { // res_sim900(); сброс sim900
_0x92:
	LDI  R30,LOW(100)
	CP   R30,R6
	BRNE _0x95
; 0000 029E switch (push){
	MOV  R30,R8
	RCALL SUBOPT_0x11
; 0000 029F case 0:{
	SBIW R30,0
	BRNE _0x99
; 0000 02A0         key_repit(); // выкл.модуль sim900
	RCALL _key_repit
; 0000 02A1        }
; 0000 02A2 break;
	RJMP _0x98
; 0000 02A3 case 1:{
_0x99:
	RCALL SUBOPT_0x12
	BRNE _0x9A
; 0000 02A4         if (Timer[2].flag == 0) { // ждём 2сек.
	RCALL SUBOPT_0x1A
	BRNE _0x9B
; 0000 02A5             push++;  // второе нажатие (вкл.)
	INC  R8
; 0000 02A6                                 }
; 0000 02A7        }
_0x9B:
; 0000 02A8 break;
	RJMP _0x98
; 0000 02A9 case 2:{
_0x9A:
	RCALL SUBOPT_0x15
	BRNE _0x9C
; 0000 02AA         key_repit(); // вкл.модуль sim900
	RCALL _key_repit
; 0000 02AB        }
; 0000 02AC break;
	RJMP _0x98
; 0000 02AD case 3:{
_0x9C:
	RCALL SUBOPT_0x16
	BRNE _0x98
; 0000 02AE         sim900 = 0;
	CLR  R6
; 0000 02AF         ATflag = 1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 02B0         iniflag = 1;
	MOV  R4,R30
; 0000 02B1         push = 0;
	CLR  R8
; 0000 02B2        }
; 0000 02B3 break;
; 0000 02B4              }
_0x98:
; 0000 02B5                    }
; 0000 02B6          }
_0x95:
	RJMP _0x43
; 0000 02B7                }
_0x9E:
	RJMP _0x9E
;
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

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
_puts:
	ST   -Y,R17
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	RCALL SUBOPT_0x2C
	RJMP _0x2060001
_putsf:
	ST   -Y,R17
_0x2000006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000008
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000006
_0x2000008:
	RCALL SUBOPT_0x2C
	RJMP _0x2060001
_gets:
	RCALL __SAVELOCR6
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2000009:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x200000B
_0x200000C:
	RCALL _getchar
	MOV  R21,R30
	CPI  R21,8
	BRNE _0x200000D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R16,R26
	CPC  R17,R27
	BRSH _0x200000E
	__SUBWRN 18,19,1
	__ADDWRN 16,17,1
_0x200000E:
	RJMP _0x200000C
_0x200000D:
	CPI  R21,10
	BREQ _0x200000B
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOV  R30,R21
	POP  R26
	POP  R27
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0x2000009
_0x200000B:
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
_put_usart_G100:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060001:
	ADIW R28,3
	RET
__print_G100:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x2D
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x2D
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x2E
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x33
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x33
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x34
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x34
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x2D
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x33
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x33
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x30
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x2D
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x30
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x9
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x9
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x9
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET

	.CSEG
_memcmpf:
    clr  r0
    clr  r22
    ld   r24,y+
    ld   r25,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
memcmpf0:
    adiw r24,0
    breq memcmpf1
    sbiw r24,1
    ld   r22,x+
	lpm  r0,z+
    cp   r22,r0
    breq memcmpf0
memcmpf1:
    sub  r22,r0
    brcc memcmpf2
    ldi  r30,-1
    ret
memcmpf2:
    ldi  r30,0
    breq memcmpf3
    inc  r30
memcmpf3:
    ret
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x64
_Timer_G000:
	.BYTE 0xC
_text:
	.BYTE 0xB
_get_phone:
	.BYTE 0xD
_get_ready:
	.BYTE 0x6
_buff:
	.BYTE 0x3

	.ESEG
_alarm:
	.DB  0x0

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _Timer_G000,1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(254)
	OUT  0x2D,R30
	LDI  R30,LOW(36)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LD   R30,Y
	LDI  R26,LOW(3)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	SET
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _soft_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 89 TIMES, CODE SIZE REDUCTION:86 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x9
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	LDI  R30,LOW(34)
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x9
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _soft_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0xE:
	LDS  R30,_Timer_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x9
	RJMP _putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	__GETB1MN _Timer_G000,3
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x11:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x9
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP _soft_delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	RCALL SUBOPT_0x9
	RJMP _pwrkey_change

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__GETB1MN _Timer_G000,6
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	MOV  R5,R13
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(_get_ready)
	LDI  R31,HIGH(_get_ready)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(_Ready*2)
	LDI  R31,HIGH(_Ready*2)
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	RCALL _memcmpf
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(_get_phone)
	LDI  R31,HIGH(_get_phone)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(_my_phone*2)
	LDI  R31,HIGH(_my_phone*2)
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(_buff)
	LDI  R31,HIGH(_buff)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x29:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_text)
	SBCI R27,HIGH(-_text)
	LD   R30,Y
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	LPM  R30,Z
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2D:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x9
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x30:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x9
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x2E
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
