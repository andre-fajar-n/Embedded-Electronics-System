;=====LCD INITIALIZATION=====
INIT:
    MOV P1, #00000000B ;DB
    CLR P2.7 ; Enable
    CLR P2.6 ; RS
;Function set
    MOV P1, #30H
    ACALL DELAY
    SETB P2.7
    ACALL DELAY
    CLR P2.7
    ACALL DELAY
;Display on
    MOV P1, #0CH
    ACALL DELAY
    SETB P2.7
    ACALL DELAY
    CLR P2.7
    ACALL DELAY
;Entry mode
    MOV P1, #06H
    ACALL DELAY
    SETB P2.7
    ACALL DELAY
    CLR P2.7
    ACALL DELAY
;=========MAIN PROGRAM========

START:
    JB P2.0, START

START2:
    JNB P2.0, START2
    SJMP INITA

DIVIDER:
    MOV B, #100
    DIV AB
    ACALL PRINT
    MOV B, #10
    DIV AB
    ACALL PRINT
    MOV B, #1
    DIV AB
    ACALL PRINT
    ACALL DELAY
 
CLEAR:
    MOV P1, #01H ;DB
    CLR P2.7
    CLR P2.6
    ACALL DELAY
    SETB P2.7
    ACALL DELAY
    CLR P2.7
    ACALL DELAY
    SJMP START
INITA:
    MOV A, #00

TIMER:
    INC A
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JB P2.0, TIMER
    SJMP DIVIDER

PRINT:
    SETB P2.6
    ADD A, #48  ;conv to ascii hex
    MOV P1, A ;write in lcd
    ACALL DELAY
    SETB P2.7
    ACALL DELAY
    CLR P2.7
    ACALL DELAY
    MOV A, B
    RET

;=======Delay======

TUNGGU:
    JNB TF0, TUNGGU
    CLR TF0
    CLR TR0
    RET
 
DELAY:
    MOV TH0, #085H
    MOV TL0, #0C7H
    SETB TR0
    JMP TUNGGU
 
END