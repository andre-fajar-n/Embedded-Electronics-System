
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _waktu_on=R4
	.DEF _waktu_on_msb=R5
	.DEF _header_start=R6
	.DEF _header_start_msb=R7
	.DEF _header_stop=R8
	.DEF _header_stop_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _waktu_ke=R12
	.DEF _waktu_ke_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x60,0x9,0x40,0x1F

_0x0:
	.DB  0x53,0x65,0x72,0x76,0x6F,0x20,0x31,0x3A
	.DB  0x20,0x25,0x33,0x64,0x0,0x53,0x65,0x72
	.DB  0x76,0x6F,0x20,0x32,0x3A,0x20,0x25,0x33
	.DB  0x64,0x0,0x53,0x65,0x72,0x76,0x6F,0x20
	.DB  0x33,0x3A,0x20,0x25,0x33,0x64,0x0,0x53
	.DB  0x65,0x72,0x76,0x6F,0x20,0x34,0x3A,0x20
	.DB  0x25,0x33,0x64,0x0,0x53,0x65,0x72,0x76
	.DB  0x6F,0x20,0x35,0x3A,0x20,0x25,0x33,0x64
	.DB  0x0,0x53,0x65,0x72,0x76,0x6F,0x20,0x36
	.DB  0x3A,0x20,0x25,0x33,0x64,0x0,0x53,0x65
	.DB  0x72,0x76,0x6F,0x20,0x37,0x3A,0x20,0x25
	.DB  0x33,0x64,0x0,0x53,0x65,0x72,0x76,0x6F
	.DB  0x20,0x38,0x3A,0x20,0x25,0x33,0x64,0x0
	.DB  0x4D,0x65,0x6E,0x67,0x69,0x72,0x69,0x6D
	.DB  0x2E,0x2E,0x2E,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0C
	.DW  _0x40
	.DW  _0x0*2+104

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <stdio.h>
;#include <delay.h>
;
;#define high 0
;#define low 1
;
;#define baris1 PORTC.3
;#define baris2 PORTC.2
;#define baris3 PORTC.1
;#define baris4 PORTC.0
;#define kolom1 PINC.7
;#define kolom2 PINC.6
;#define kolom3 PINC.5
;#define kolom4 PINC.4
;
;#define baris1_on PORTC.3=1
;#define baris2_on PORTC.2=1
;#define baris3_on PORTC.1=1
;#define baris4_on PORTC.0=1
;#define baris1_off PORTC.3=0
;#define baris2_off PORTC.2=0
;#define baris3_off PORTC.1=0
;#define baris4_off PORTC.0=0
;
;unsigned int waktu_on = 2400, header_start=8000, header_stop;
;int sudut_servo[8],ocr_servo[8], i;
;int waktu_ke;
;char tampil[16];
;
;unsigned int sudut2ocr(unsigned int sudut_x){
; 0000 0020 unsigned int sudut2ocr(unsigned int sudut_x){

	.CSEG
_sudut2ocr:
; .FSTART _sudut2ocr
; 0000 0021     int duty_ocr;
; 0000 0022     duty_ocr=sudut_x*44.444444444+8000;
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	sudut_x -> Y+2
;	duty_ocr -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x4231C71C
	CALL __MULF12
	__GETD2N 0x45FA0000
	CALL __ADDF12
	CALL __CFD1
	MOVW R16,R30
; 0000 0023     return duty_ocr;
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; 0000 0024 }
; .FEND
;
;void input_keypad_loop(){
; 0000 0026 void input_keypad_loop(){
_input_keypad_loop:
; .FSTART _input_keypad_loop
; 0000 0027     for(i=0;i<4;i++){
	CLR  R10
	CLR  R11
_0x4:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R10,R30
	CPC  R11,R31
	BRLT PC+2
	RJMP _0x5
; 0000 0028         PORTC=0xF0;
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0029         if(i==0)PORTC=7;//0b11110111;
	MOV  R0,R10
	OR   R0,R11
	BRNE _0x6
	LDI  R30,LOW(7)
	RJMP _0x7E
; 0000 002A         else if(i==1)PORTC=11;//0b11111011;
_0x6:
	CALL SUBOPT_0x0
	BRNE _0x8
	LDI  R30,LOW(11)
	RJMP _0x7E
; 0000 002B         else if(i==2)PORTC=13;//0b11111101;
_0x8:
	CALL SUBOPT_0x1
	BRNE _0xA
	LDI  R30,LOW(13)
	RJMP _0x7E
; 0000 002C         else if(i==3)PORTC=14;//0b11111110;
_0xA:
	CALL SUBOPT_0x2
	BRNE _0xC
	LDI  R30,LOW(14)
_0x7E:
	OUT  0x15,R30
; 0000 002D         if(kolom1==0){
_0xC:
	SBIC 0x13,7
	RJMP _0xD
; 0000 002E             lcd_clear();
	CALL _lcd_clear
; 0000 002F             while(kolom1==0){
_0xE:
	SBIC 0x13,7
	RJMP _0x10
; 0000 0030             lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0031             if(i==0){
	BRNE _0x11
; 0000 0032                 sudut_servo[0]+=1;
	CALL SUBOPT_0x4
	ADIW R30,1
	CALL SUBOPT_0x5
; 0000 0033                 if(sudut_servo[0]>180)sudut_servo[0]=0;
	CALL SUBOPT_0x6
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x12
	LDI  R30,LOW(0)
	STS  _sudut_servo,R30
	STS  _sudut_servo+1,R30
; 0000 0034                 sprintf(tampil,"Servo 1: %3d",sudut_servo[0]);
_0x12:
	CALL SUBOPT_0x7
; 0000 0035                 ocr_servo[0]=sudut2ocr(sudut_servo[0]);
; 0000 0036             }
; 0000 0037             if(i==1){
_0x11:
	CALL SUBOPT_0x0
	BRNE _0x13
; 0000 0038                 sudut_servo[0]-=1;
	CALL SUBOPT_0x4
	SBIW R30,1
	CALL SUBOPT_0x5
; 0000 0039                 if(sudut_servo[0]<0)sudut_servo[0]=180;
	LDS  R26,_sudut_servo+1
	TST  R26
	BRPL _0x14
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x5
; 0000 003A                 sprintf(tampil,"Servo 1: %3d",sudut_servo[0]);
_0x14:
	CALL SUBOPT_0x7
; 0000 003B                 ocr_servo[0]=sudut2ocr(sudut_servo[0]);
; 0000 003C             }
; 0000 003D             if(i==2){
_0x13:
	CALL SUBOPT_0x1
	BRNE _0x15
; 0000 003E                 sudut_servo[1]+=1;
	CALL SUBOPT_0x8
	ADIW R30,1
	__PUTW1MN _sudut_servo,2
; 0000 003F                 if(sudut_servo[1]>180)sudut_servo[1]=0;
	CALL SUBOPT_0x9
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x16
	CALL SUBOPT_0xA
; 0000 0040                 sprintf(tampil,"Servo 2: %3d",sudut_servo[1]);
_0x16:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 0041                 ocr_servo[1]=sudut2ocr(sudut_servo[1]);
	CALL SUBOPT_0xD
; 0000 0042             }
; 0000 0043             if(i==3){
_0x15:
	CALL SUBOPT_0x2
	BRNE _0x17
; 0000 0044                 sudut_servo[1]-=1;
	CALL SUBOPT_0x8
	SBIW R30,1
	__PUTW1MN _sudut_servo,2
; 0000 0045                 if(sudut_servo[1]<0)sudut_servo[1]=180;
	__GETB2MN _sudut_servo,3
	TST  R26
	BRPL _0x18
	__POINTW1MN _sudut_servo,2
	CALL SUBOPT_0xE
; 0000 0046                 sprintf(tampil,"Servo 2: %3d",sudut_servo[1]);
_0x18:
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 0047                 ocr_servo[1]=sudut2ocr(sudut_servo[1]);
	CALL SUBOPT_0xD
; 0000 0048             }
; 0000 0049             lcd_puts(tampil);
_0x17:
	CALL SUBOPT_0xF
; 0000 004A             lcd_gotoxy(12,0);
; 0000 004B             lcd_putchar(0xDF);
; 0000 004C             delay_ms(100);
; 0000 004D             }
	RJMP _0xE
_0x10:
; 0000 004E         }
; 0000 004F         else if(kolom2==0){
	RJMP _0x19
_0xD:
	SBIC 0x13,6
	RJMP _0x1A
; 0000 0050             lcd_clear();
	CALL _lcd_clear
; 0000 0051             while(kolom2==0){
_0x1B:
	SBIC 0x13,6
	RJMP _0x1D
; 0000 0052             lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0053             if(i==0){
	BRNE _0x1E
; 0000 0054                 sudut_servo[2]+=1;
	CALL SUBOPT_0x10
	ADIW R30,1
	__PUTW1MN _sudut_servo,4
; 0000 0055                 if(sudut_servo[2]>180)sudut_servo[2]=0;
	CALL SUBOPT_0x11
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x1F
	CALL SUBOPT_0x12
; 0000 0056                 sprintf(tampil,"Servo 3: %3d",sudut_servo[2]);
_0x1F:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 0057                 ocr_servo[2]=sudut2ocr(sudut_servo[2]);
	CALL SUBOPT_0x15
; 0000 0058             }
; 0000 0059             if(i==1){
_0x1E:
	CALL SUBOPT_0x0
	BRNE _0x20
; 0000 005A                 sudut_servo[2]-=1;
	CALL SUBOPT_0x10
	SBIW R30,1
	__PUTW1MN _sudut_servo,4
; 0000 005B                 if(sudut_servo[2]<0)sudut_servo[2]=180;
	__GETB2MN _sudut_servo,5
	TST  R26
	BRPL _0x21
	__POINTW1MN _sudut_servo,4
	CALL SUBOPT_0xE
; 0000 005C                 sprintf(tampil,"Servo 3: %3d",sudut_servo[2]);
_0x21:
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
; 0000 005D                 ocr_servo[2]=sudut2ocr(sudut_servo[2]);
	CALL SUBOPT_0x15
; 0000 005E             }
; 0000 005F             if(i==2){
_0x20:
	CALL SUBOPT_0x1
	BRNE _0x22
; 0000 0060                 sudut_servo[3]+=1;
	CALL SUBOPT_0x16
	ADIW R30,1
	__PUTW1MN _sudut_servo,6
; 0000 0061                 if(sudut_servo[3]>180)sudut_servo[3]=0;
	CALL SUBOPT_0x17
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x23
	CALL SUBOPT_0x18
; 0000 0062                 sprintf(tampil,"Servo 4: %3d",sudut_servo[3]);
_0x23:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 0063                 ocr_servo[3]=sudut2ocr(sudut_servo[3]);
	CALL SUBOPT_0x1B
; 0000 0064             }
; 0000 0065             if(i==3){
_0x22:
	CALL SUBOPT_0x2
	BRNE _0x24
; 0000 0066                 sudut_servo[3]-=1;
	CALL SUBOPT_0x16
	SBIW R30,1
	__PUTW1MN _sudut_servo,6
; 0000 0067                 if(sudut_servo[3]<0)sudut_servo[3]=180;
	__GETB2MN _sudut_servo,7
	TST  R26
	BRPL _0x25
	__POINTW1MN _sudut_servo,6
	CALL SUBOPT_0xE
; 0000 0068                 sprintf(tampil,"Servo 4: %3d",sudut_servo[3]);
_0x25:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
; 0000 0069                 ocr_servo[3]=sudut2ocr(sudut_servo[3]);
	CALL SUBOPT_0x1B
; 0000 006A             }
; 0000 006B             lcd_puts(tampil);
_0x24:
	CALL SUBOPT_0xF
; 0000 006C             lcd_gotoxy(12,0);
; 0000 006D             lcd_putchar(0xDF);
; 0000 006E             delay_ms(100);
; 0000 006F             }
	RJMP _0x1B
_0x1D:
; 0000 0070         }
; 0000 0071         else if(kolom3==0){
	RJMP _0x26
_0x1A:
	SBIC 0x13,5
	RJMP _0x27
; 0000 0072             lcd_clear();
	CALL _lcd_clear
; 0000 0073             while(kolom3==0){
_0x28:
	SBIC 0x13,5
	RJMP _0x2A
; 0000 0074             lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0075             if(i==0){
	BRNE _0x2B
; 0000 0076                 sudut_servo[4]+=1;
	CALL SUBOPT_0x1C
	ADIW R30,1
	__PUTW1MN _sudut_servo,8
; 0000 0077                 if(sudut_servo[4]>180)sudut_servo[4]=0;
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x2C
	CALL SUBOPT_0x1E
; 0000 0078                 sprintf(tampil,"Servo 5: %3d",sudut_servo[4]);
_0x2C:
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 0079                 ocr_servo[4]=sudut2ocr(sudut_servo[4]);
	CALL SUBOPT_0x21
; 0000 007A             }
; 0000 007B             if(i==1){
_0x2B:
	CALL SUBOPT_0x0
	BRNE _0x2D
; 0000 007C                 sudut_servo[4]-=1;
	CALL SUBOPT_0x1C
	SBIW R30,1
	__PUTW1MN _sudut_servo,8
; 0000 007D                 if(sudut_servo[4]<0)sudut_servo[4]=180;
	__GETB2MN _sudut_servo,9
	TST  R26
	BRPL _0x2E
	__POINTW1MN _sudut_servo,8
	CALL SUBOPT_0xE
; 0000 007E                 sprintf(tampil,"Servo 5: %3d",sudut_servo[4]);
_0x2E:
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 007F                 ocr_servo[4]=sudut2ocr(sudut_servo[4]);
	CALL SUBOPT_0x21
; 0000 0080             }
; 0000 0081             if(i==2){
_0x2D:
	CALL SUBOPT_0x1
	BRNE _0x2F
; 0000 0082                 sudut_servo[5]+=1;
	CALL SUBOPT_0x22
	ADIW R30,1
	__PUTW1MN _sudut_servo,10
; 0000 0083                 if(sudut_servo[5]>180)sudut_servo[5]=0;
	CALL SUBOPT_0x23
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x30
	CALL SUBOPT_0x24
; 0000 0084                 sprintf(tampil,"Servo 6: %3d",sudut_servo[5]);
_0x30:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 0085                 ocr_servo[5]=sudut2ocr(sudut_servo[5]);
	CALL SUBOPT_0x27
; 0000 0086             }
; 0000 0087             if(i==3){
_0x2F:
	CALL SUBOPT_0x2
	BRNE _0x31
; 0000 0088                 sudut_servo[5]-=1;
	CALL SUBOPT_0x22
	SBIW R30,1
	__PUTW1MN _sudut_servo,10
; 0000 0089                 if(sudut_servo[5]<0)sudut_servo[5]=180;
	__GETB2MN _sudut_servo,11
	TST  R26
	BRPL _0x32
	__POINTW1MN _sudut_servo,10
	CALL SUBOPT_0xE
; 0000 008A                 sprintf(tampil,"Servo 6: %3d",sudut_servo[5]);
_0x32:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 008B                 ocr_servo[5]=sudut2ocr(sudut_servo[5]);
	CALL SUBOPT_0x27
; 0000 008C             }
; 0000 008D             lcd_puts(tampil);
_0x31:
	CALL SUBOPT_0xF
; 0000 008E             lcd_gotoxy(12,0);
; 0000 008F             lcd_putchar(0xDF);
; 0000 0090             delay_ms(100);
; 0000 0091             }
	RJMP _0x28
_0x2A:
; 0000 0092         }
; 0000 0093         else if(kolom4==0){
	RJMP _0x33
_0x27:
	SBIC 0x13,4
	RJMP _0x34
; 0000 0094             lcd_clear();
	CALL _lcd_clear
; 0000 0095             while(kolom4==0){
_0x35:
	SBIC 0x13,4
	RJMP _0x37
; 0000 0096             lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0097             if(i==0){
	BRNE _0x38
; 0000 0098                 sudut_servo[6]+=1;
	CALL SUBOPT_0x28
	ADIW R30,1
	__PUTW1MN _sudut_servo,12
; 0000 0099                 if(sudut_servo[6]>180)sudut_servo[6]=0;
	CALL SUBOPT_0x29
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x39
	CALL SUBOPT_0x2A
; 0000 009A                 sprintf(tampil,"Servo 7: %3d",sudut_servo[6]);
_0x39:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 009B                 ocr_servo[6]=sudut2ocr(sudut_servo[6]);
	CALL SUBOPT_0x2D
; 0000 009C             }
; 0000 009D             if(i==1){
_0x38:
	CALL SUBOPT_0x0
	BRNE _0x3A
; 0000 009E                 sudut_servo[6]-=1;
	CALL SUBOPT_0x28
	SBIW R30,1
	__PUTW1MN _sudut_servo,12
; 0000 009F                 if(sudut_servo[6]<0)sudut_servo[6]=180;
	__GETB2MN _sudut_servo,13
	TST  R26
	BRPL _0x3B
	__POINTW1MN _sudut_servo,12
	CALL SUBOPT_0xE
; 0000 00A0                 sprintf(tampil,"Servo 7: %3d",sudut_servo[6]);
_0x3B:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 00A1                 ocr_servo[6]=sudut2ocr(sudut_servo[6]);
	CALL SUBOPT_0x2D
; 0000 00A2             }
; 0000 00A3             if(i==2){
_0x3A:
	CALL SUBOPT_0x1
	BRNE _0x3C
; 0000 00A4                 sudut_servo[7]+=1;
	CALL SUBOPT_0x2E
	ADIW R30,1
	__PUTW1MN _sudut_servo,14
; 0000 00A5                 if(sudut_servo[7]>180)sudut_servo[7]=0;
	CALL SUBOPT_0x2F
	CPI  R26,LOW(0xB5)
	LDI  R30,HIGH(0xB5)
	CPC  R27,R30
	BRLT _0x3D
	CALL SUBOPT_0x30
; 0000 00A6                 sprintf(tampil,"Servo 8: %3d",sudut_servo[7]);
_0x3D:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
; 0000 00A7                 ocr_servo[7]=sudut2ocr(sudut_servo[7]);
	CALL SUBOPT_0x33
; 0000 00A8             }
; 0000 00A9             if(i==3){
_0x3C:
	CALL SUBOPT_0x2
	BRNE _0x3E
; 0000 00AA                 sudut_servo[7]-=1;
	CALL SUBOPT_0x2E
	SBIW R30,1
	__PUTW1MN _sudut_servo,14
; 0000 00AB                 if(sudut_servo[7]<0)sudut_servo[7]=180;
	__GETB2MN _sudut_servo,15
	TST  R26
	BRPL _0x3F
	__POINTW1MN _sudut_servo,14
	CALL SUBOPT_0xE
; 0000 00AC                 sprintf(tampil,"Servo 8: %3d",sudut_servo[7]);
_0x3F:
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
; 0000 00AD                 ocr_servo[7]=sudut2ocr(sudut_servo[7]);
	CALL SUBOPT_0x33
; 0000 00AE             }
; 0000 00AF             lcd_puts(tampil);
_0x3E:
	CALL SUBOPT_0xF
; 0000 00B0             lcd_gotoxy(12,0);
; 0000 00B1             lcd_putchar(0xDF);
; 0000 00B2             delay_ms(100);
; 0000 00B3             }
	RJMP _0x35
_0x37:
; 0000 00B4         }
; 0000 00B5 //        else{
; 0000 00B6 //            lcd_gotoxy(0,0);
; 0000 00B7 //           lcd_puts("TIDAK TEKAN");
; 0000 00B8 //        }
; 0000 00B9         header_stop=ocr_servo[0]+ocr_servo[1]+ocr_servo[2];
_0x34:
_0x33:
_0x26:
_0x19:
	CALL SUBOPT_0x34
	LDS  R26,_ocr_servo
	LDS  R27,_ocr_servo+1
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x35
	ADD  R30,R26
	ADC  R31,R27
	MOVW R8,R30
; 0000 00BA         header_stop+=ocr_servo[3]+ocr_servo[4]+ocr_servo[5];
	__GETW2MN _ocr_servo,6
	CALL SUBOPT_0x36
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x37
	ADD  R30,R26
	ADC  R31,R27
	__ADDWRR 8,9,30,31
; 0000 00BB         header_stop+=ocr_servo[6]+ocr_servo[7];
	__GETW2MN _ocr_servo,12
	CALL SUBOPT_0x38
	ADD  R30,R26
	ADC  R31,R27
	__ADDWRR 8,9,30,31
; 0000 00BC         header_stop=152800-header_stop;
	LDI  R30,LOW(21728)
	LDI  R31,HIGH(21728)
	SUB  R30,R8
	SBC  R31,R9
	MOVW R8,R30
; 0000 00BD         lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 00BE         lcd_puts("Mengirim...");
	__POINTW2MN _0x40,0
	CALL _lcd_puts
; 0000 00BF     }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x4
_0x5:
; 0000 00C0 }
	RET
; .FEND

	.DSEG
_0x40:
	.BYTE 0xC
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void){
; 0000 00C3 interrupt [7] void timer1_compa_isr(void){

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00C4 switch(waktu_ke){
	MOVW R30,R12
; 0000 00C5     case 0:
	SBIW R30,0
	BRNE _0x44
; 0000 00C6         OCR1AH=header_stop>>8;
	MOV  R30,R9
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
; 0000 00C7         OCR1AL=header_stop && 0xFF;
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x45
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x45
	LDI  R30,1
	RJMP _0x46
_0x45:
	LDI  R30,0
_0x46:
	OUT  0x2A,R30
; 0000 00C8         waktu_ke=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 00C9         break;
	RJMP _0x43
; 0000 00CA     case 1:
_0x44:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x47
; 0000 00CB         OCR1AH=header_start >>8;
	MOV  R30,R7
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
; 0000 00CC         OCR1AL=header_start && 0xFF;
	MOV  R0,R6
	OR   R0,R7
	BREQ _0x48
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x48
	LDI  R30,1
	RJMP _0x49
_0x48:
	LDI  R30,0
_0x49:
	OUT  0x2A,R30
; 0000 00CD         waktu_ke=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 00CE         break;
	RJMP _0x43
; 0000 00CF     case 2:
_0x47:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4A
; 0000 00D0         OCR1AH=ocr_servo[0] >>8;
	LDS  R30,_ocr_servo
	LDS  R31,_ocr_servo+1
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 00D1         OCR1AL=ocr_servo[0] && 0xFF;
	LDS  R30,_ocr_servo
	LDS  R31,_ocr_servo+1
	SBIW R30,0
	BREQ _0x4B
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x4B
	LDI  R30,1
	RJMP _0x4C
_0x4B:
	LDI  R30,0
_0x4C:
	OUT  0x2A,R30
; 0000 00D2         waktu_ke=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R12,R30
; 0000 00D3         break;
	RJMP _0x43
; 0000 00D4     case 3:
_0x4A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4D
; 0000 00D5         OCR1AH=waktu_on >>8;
	CALL SUBOPT_0x39
; 0000 00D6         OCR1AL=waktu_on && 0xFF;
	BREQ _0x4E
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x4E
	LDI  R30,1
	RJMP _0x4F
_0x4E:
	LDI  R30,0
_0x4F:
	OUT  0x2A,R30
; 0000 00D7         waktu_ke=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R12,R30
; 0000 00D8         break;
	RJMP _0x43
; 0000 00D9     case 4:
_0x4D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x50
; 0000 00DA         OCR1AH=ocr_servo[1] >>8;
	CALL SUBOPT_0x34
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 00DB         OCR1AL=ocr_servo[1] && 0xFF;
	CALL SUBOPT_0x34
	SBIW R30,0
	BREQ _0x51
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x51
	LDI  R30,1
	RJMP _0x52
_0x51:
	LDI  R30,0
_0x52:
	OUT  0x2A,R30
; 0000 00DC         waktu_ke=5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R12,R30
; 0000 00DD         break;
	RJMP _0x43
; 0000 00DE     case 5:
_0x50:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x53
; 0000 00DF         OCR1AH=waktu_on >>8;
	CALL SUBOPT_0x39
; 0000 00E0         OCR1AL=waktu_on && 0xFF;
	BREQ _0x54
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x54
	LDI  R30,1
	RJMP _0x55
_0x54:
	LDI  R30,0
_0x55:
	OUT  0x2A,R30
; 0000 00E1         waktu_ke=6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	MOVW R12,R30
; 0000 00E2         break;
	RJMP _0x43
; 0000 00E3     case 6:
_0x53:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x56
; 0000 00E4         OCR1AH=ocr_servo[2] >>8;
	CALL SUBOPT_0x35
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 00E5         OCR1AL=ocr_servo[2] && 0xFF;
	CALL SUBOPT_0x35
	SBIW R30,0
	BREQ _0x57
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x57
	LDI  R30,1
	RJMP _0x58
_0x57:
	LDI  R30,0
_0x58:
	OUT  0x2A,R30
; 0000 00E6         waktu_ke=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R12,R30
; 0000 00E7         break;
	RJMP _0x43
; 0000 00E8     case 7:
_0x56:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x59
; 0000 00E9         OCR1AH=waktu_on >>8;
	CALL SUBOPT_0x39
; 0000 00EA         OCR1AL=waktu_on && 0xFF;
	BREQ _0x5A
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x5A
	LDI  R30,1
	RJMP _0x5B
_0x5A:
	LDI  R30,0
_0x5B:
	OUT  0x2A,R30
; 0000 00EB         waktu_ke=8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R12,R30
; 0000 00EC         break;
	RJMP _0x43
; 0000 00ED     case 8:
_0x59:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x5C
; 0000 00EE         OCR1AH=ocr_servo[3] >>8;
	__GETW1MN _ocr_servo,6
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 00EF         OCR1AL=ocr_servo[3] && 0xFF;
	__GETW1MN _ocr_servo,6
	SBIW R30,0
	BREQ _0x5D
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x5D
	LDI  R30,1
	RJMP _0x5E
_0x5D:
	LDI  R30,0
_0x5E:
	OUT  0x2A,R30
; 0000 00F0         waktu_ke=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R12,R30
; 0000 00F1         break;
	RJMP _0x43
; 0000 00F2     case 9:
_0x5C:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x5F
; 0000 00F3         OCR1AH=waktu_on >>8;
	CALL SUBOPT_0x39
; 0000 00F4         OCR1AL=waktu_on && 0xFF;
	BREQ _0x60
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x60
	LDI  R30,1
	RJMP _0x61
_0x60:
	LDI  R30,0
_0x61:
	OUT  0x2A,R30
; 0000 00F5         waktu_ke=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R12,R30
; 0000 00F6         break;
	RJMP _0x43
; 0000 00F7     case 10:
_0x5F:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x62
; 0000 00F8         OCR1AH=ocr_servo[4] >>8;
	CALL SUBOPT_0x36
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 00F9         OCR1AL=ocr_servo[4] && 0xFF;
	CALL SUBOPT_0x36
	SBIW R30,0
	BREQ _0x63
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x63
	LDI  R30,1
	RJMP _0x64
_0x63:
	LDI  R30,0
_0x64:
	OUT  0x2A,R30
; 0000 00FA         waktu_ke=11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R12,R30
; 0000 00FB         break;
	RJMP _0x43
; 0000 00FC     case 11:
_0x62:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x65
; 0000 00FD         OCR1AH=waktu_on >>8;
	CALL SUBOPT_0x39
; 0000 00FE         OCR1AL=waktu_on && 0xFF;
	BREQ _0x66
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x66
	LDI  R30,1
	RJMP _0x67
_0x66:
	LDI  R30,0
_0x67:
	OUT  0x2A,R30
; 0000 00FF         waktu_ke=12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	MOVW R12,R30
; 0000 0100         break;
	RJMP _0x43
; 0000 0101     case 12:
_0x65:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x68
; 0000 0102         OCR1AH=ocr_servo[5] >>8;
	CALL SUBOPT_0x37
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 0103         OCR1AL=ocr_servo[5] && 0xFF;
	CALL SUBOPT_0x37
	SBIW R30,0
	BREQ _0x69
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x69
	LDI  R30,1
	RJMP _0x6A
_0x69:
	LDI  R30,0
_0x6A:
	OUT  0x2A,R30
; 0000 0104         waktu_ke=13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	MOVW R12,R30
; 0000 0105         break;
	RJMP _0x43
; 0000 0106     case 13:
_0x68:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x6B
; 0000 0107         OCR1AH=waktu_on >>8;
	CALL SUBOPT_0x39
; 0000 0108         OCR1AL=waktu_on && 0xFF;
	BREQ _0x6C
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x6C
	LDI  R30,1
	RJMP _0x6D
_0x6C:
	LDI  R30,0
_0x6D:
	OUT  0x2A,R30
; 0000 0109         waktu_ke=14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	MOVW R12,R30
; 0000 010A         break;
	RJMP _0x43
; 0000 010B     case 14:
_0x6B:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x6E
; 0000 010C         OCR1AH=ocr_servo[6] >>8;
	__GETW1MN _ocr_servo,12
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 010D         OCR1AL=ocr_servo[6] && 0xFF;
	__GETW1MN _ocr_servo,12
	SBIW R30,0
	BREQ _0x6F
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x6F
	LDI  R30,1
	RJMP _0x70
_0x6F:
	LDI  R30,0
_0x70:
	OUT  0x2A,R30
; 0000 010E         waktu_ke=15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R12,R30
; 0000 010F         break;
	RJMP _0x43
; 0000 0110     case 15:
_0x6E:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x71
; 0000 0111         OCR1AH=waktu_on>>8;
	CALL SUBOPT_0x39
; 0000 0112         OCR1AL=waktu_on && 0xFF;
	BREQ _0x72
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x72
	LDI  R30,1
	RJMP _0x73
_0x72:
	LDI  R30,0
_0x73:
	OUT  0x2A,R30
; 0000 0113         waktu_ke=16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	MOVW R12,R30
; 0000 0114         break;
	RJMP _0x43
; 0000 0115     case 16:
_0x71:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x74
; 0000 0116         OCR1AH=ocr_servo[7]>>8;
	CALL SUBOPT_0x38
	CALL __ASRW8
	OUT  0x2B,R30
; 0000 0117         OCR1AL=ocr_servo[7] && 0xFF;
	CALL SUBOPT_0x38
	SBIW R30,0
	BREQ _0x75
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x75
	LDI  R30,1
	RJMP _0x76
_0x75:
	LDI  R30,0
_0x76:
	OUT  0x2A,R30
; 0000 0118         waktu_ke=17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	MOVW R12,R30
; 0000 0119         break;
	RJMP _0x43
; 0000 011A     case 17:
_0x74:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x43
; 0000 011B         OCR1AH=waktu_on>>8;
	CALL SUBOPT_0x39
; 0000 011C         OCR1AL=waktu_on && 0xFF;
	BREQ _0x78
	LDI  R30,LOW(255)
	CPI  R30,0
	BREQ _0x78
	LDI  R30,1
	RJMP _0x79
_0x78:
	LDI  R30,0
_0x79:
	OUT  0x2A,R30
; 0000 011D         waktu_ke=0;
	CLR  R12
	CLR  R13
; 0000 011E         break;
; 0000 011F }
_0x43:
; 0000 0120 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0123 {
_main:
; .FSTART _main
; 0000 0124 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0125 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0126 
; 0000 0127 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0128 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0129 
; 0000 012A DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 012B PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 012C 
; 0000 012D DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 012E PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 012F 
; 0000 0130 // Timer/Counter 1 initialization
; 0000 0131 // Clock source: System Clock
; 0000 0132 // Clock value: 8000.000 kHz
; 0000 0133 // Mode: Normal top=0xFFFF
; 0000 0134 // OC1A output: Clear on compare match
; 0000 0135 // OC1B output: Clear on compare match
; 0000 0136 // Noise Canceler: Off
; 0000 0137 // Input Capture on Falling Edge
; 0000 0138 // Timer Period: 2 ms
; 0000 0139 // Output Pulse(s):
; 0000 013A // OC1A Period: 2 ms
; 0000 013B // OC1B Period: 2 ms
; 0000 013C // Timer1 Overflow Interrupt: On
; 0000 013D // Input Capture Interrupt: Off
; 0000 013E // Compare A Match Interrupt: Off
; 0000 013F // Compare B Match Interrupt: Off
; 0000 0140 TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 0141 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(9)
	OUT  0x2E,R30
; 0000 0142 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0143 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0144 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0145 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0146 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0147 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0148 OCR1BH=0x3E;
	LDI  R30,LOW(62)
	OUT  0x29,R30
; 0000 0149 OCR1BL=0x80;
	LDI  R30,LOW(128)
	OUT  0x28,R30
; 0000 014A 
; 0000 014B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 014C TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 014D 
; 0000 014E // Analog Comparator initialization
; 0000 014F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0150 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0151 
; 0000 0152 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0153 
; 0000 0154 // Global enable interrupts
; 0000 0155 #asm("sei")
	sei
; 0000 0156 
; 0000 0157 sudut_servo[0]=0;
	LDI  R30,LOW(0)
	STS  _sudut_servo,R30
	STS  _sudut_servo+1,R30
; 0000 0158 sudut_servo[1]=0;
	CALL SUBOPT_0xA
; 0000 0159 sudut_servo[2]=0;
	CALL SUBOPT_0x12
; 0000 015A sudut_servo[3]=0;
	CALL SUBOPT_0x18
; 0000 015B sudut_servo[4]=0;
	CALL SUBOPT_0x1E
; 0000 015C sudut_servo[5]=0;
	CALL SUBOPT_0x24
; 0000 015D sudut_servo[6]=0;
	CALL SUBOPT_0x2A
; 0000 015E sudut_servo[7]=0;
	CALL SUBOPT_0x30
; 0000 015F 
; 0000 0160 ocr_servo[0]=16000;
	LDI  R30,LOW(16000)
	LDI  R31,HIGH(16000)
	STS  _ocr_servo,R30
	STS  _ocr_servo+1,R31
; 0000 0161 ocr_servo[1]=16000;
	__POINTW1MN _ocr_servo,2
	CALL SUBOPT_0x3A
; 0000 0162 ocr_servo[2]=16000;
	__POINTW1MN _ocr_servo,4
	CALL SUBOPT_0x3A
; 0000 0163 ocr_servo[3]=16000;
	__POINTW1MN _ocr_servo,6
	CALL SUBOPT_0x3A
; 0000 0164 ocr_servo[4]=16000;
	__POINTW1MN _ocr_servo,8
	CALL SUBOPT_0x3A
; 0000 0165 ocr_servo[5]=16000;
	__POINTW1MN _ocr_servo,10
	CALL SUBOPT_0x3A
; 0000 0166 ocr_servo[6]=16000;
	__POINTW1MN _ocr_servo,12
	CALL SUBOPT_0x3A
; 0000 0167 ocr_servo[7]=16000;
	__POINTW1MN _ocr_servo,14
	CALL SUBOPT_0x3A
; 0000 0168 
; 0000 0169 while (1)
_0x7A:
; 0000 016A       {
; 0000 016B       input_keypad_loop();
	RCALL _input_keypad_loop
; 0000 016C       }
	RJMP _0x7A
; 0000 016D }
_0x7D:
	RJMP _0x7D
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x1B,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x1B,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,4
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x1B,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x1B,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,6
_0x200000B:
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x3B
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x3B
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080002
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x1A,3
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
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
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x3D
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x3D
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x3E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3F
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x40
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x40
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x41
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x3D
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x3F
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3F
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x42
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x42
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND

	.DSEG
_sudut_servo:
	.BYTE 0x10
_ocr_servo:
	.BYTE 0x10
_tampil:
	.BYTE 0x10
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	MOV  R0,R10
	OR   R0,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDS  R30,_sudut_servo
	LDS  R31,_sudut_servo+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _sudut_servo,R30
	STS  _sudut_servo+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_sudut_servo
	LDS  R27,_sudut_servo+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x4
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RCALL SUBOPT_0x6
	CALL _sudut2ocr
	STS  _ocr_servo,R30
	STS  _ocr_servo+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	__GETW1MN _sudut_servo,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETW2MN _sudut_servo,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__POINTW1MN _sudut_servo,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,13
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(180)
	LDI  R27,HIGH(180)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_tampil)
	LDI  R27,HIGH(_tampil)
	CALL _lcd_puts
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R26,LOW(223)
	CALL _lcd_putchar
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	__GETW1MN _sudut_servo,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETW2MN _sudut_servo,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__POINTW1MN _sudut_servo,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,26
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	__GETW1MN _sudut_servo,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETW2MN _sudut_servo,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__POINTW1MN _sudut_servo,6
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	__GETW1MN _sudut_servo,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETW2MN _sudut_servo,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	__POINTW1MN _sudut_servo,8
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	__GETW1MN _sudut_servo,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__GETW2MN _sudut_servo,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__POINTW1MN _sudut_servo,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,65
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	__GETW1MN _sudut_servo,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	__GETW2MN _sudut_servo,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	__POINTW1MN _sudut_servo,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,78
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	__GETW1MN _sudut_servo,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	__GETW2MN _sudut_servo,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__POINTW1MN _sudut_servo,14
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(_tampil)
	LDI  R31,HIGH(_tampil)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,91
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	CALL _sudut2ocr
	__PUTW1MN _ocr_servo,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__GETW1MN _ocr_servo,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	__GETW1MN _ocr_servo,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	__GETW1MN _ocr_servo,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETW1MN _ocr_servo,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETW1MN _ocr_servo,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x39:
	MOV  R30,R5
	ANDI R31,HIGH(0x0)
	OUT  0x2B,R30
	MOV  R0,R4
	OR   R0,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	LDI  R26,LOW(16000)
	LDI  R27,HIGH(16000)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3D:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

;END OF CODE MARKER
__END_OF_CODE:
