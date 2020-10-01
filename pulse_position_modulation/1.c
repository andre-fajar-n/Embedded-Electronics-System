#include <mega16.h>
#include <alcd.h>
#include <stdio.h>
#include <delay.h>

#define high 0
#define low 1

#define baris1 PORTC.3
#define baris2 PORTC.2
#define baris3 PORTC.1
#define baris4 PORTC.0
#define kolom1 PINC.7
#define kolom2 PINC.6
#define kolom3 PINC.5
#define kolom4 PINC.4

#define baris1_on PORTC.3=1
#define baris2_on PORTC.2=1
#define baris3_on PORTC.1=1
#define baris4_on PORTC.0=1
#define baris1_off PORTC.3=0
#define baris2_off PORTC.2=0
#define baris3_off PORTC.1=0
#define baris4_off PORTC.0=0

unsigned int waktu_on = 2400, header_start=8000, header_stop; 
int sudut_servo[8],ocr_servo[8], i;
int waktu_ke;
char tampil[16];

unsigned int sudut2ocr(unsigned int sudut_x){
    int duty_ocr;
    duty_ocr=sudut_x*44.444444444+8000;
    return duty_ocr;    
}

void input_keypad_loop(){
    for(i=0;i<4;i++){
        PORTC=0xF0;
        if(i==0)PORTC=7;//0b11110111;
        else if(i==1)PORTC=11;//0b11111011;
        else if(i==2)PORTC=13;//0b11111101;
        else if(i==3)PORTC=14;//0b11111110;
        if(kolom1==0){ 
            lcd_clear();
            while(kolom1==0){
            lcd_gotoxy(0,0);
            if(i==0){
                sudut_servo[0]+=1;  
                if(sudut_servo[0]>180)sudut_servo[0]=0;
                sprintf(tampil,"Servo 1: %3d",sudut_servo[0]);
                ocr_servo[0]=sudut2ocr(sudut_servo[0]);
            }
            if(i==1){
                sudut_servo[0]-=1;
                if(sudut_servo[0]<0)sudut_servo[0]=180;
                sprintf(tampil,"Servo 1: %3d",sudut_servo[0]);
                ocr_servo[0]=sudut2ocr(sudut_servo[0]);
            }
            if(i==2){
                sudut_servo[1]+=1;
                if(sudut_servo[1]>180)sudut_servo[1]=0;
                sprintf(tampil,"Servo 2: %3d",sudut_servo[1]);
                ocr_servo[1]=sudut2ocr(sudut_servo[1]);
            }
            if(i==3){
                sudut_servo[1]-=1;
                if(sudut_servo[1]<0)sudut_servo[1]=180;
                sprintf(tampil,"Servo 2: %3d",sudut_servo[1]); 
                ocr_servo[1]=sudut2ocr(sudut_servo[1]);
            }
            lcd_puts(tampil);
            lcd_gotoxy(12,0);
            lcd_putchar(0xDF);
            delay_ms(100);
            }
        }
        else if(kolom2==0){ 
            lcd_clear();
            while(kolom2==0){
            lcd_gotoxy(0,0);
            if(i==0){
                sudut_servo[2]+=1;  
                if(sudut_servo[2]>180)sudut_servo[2]=0;
                sprintf(tampil,"Servo 3: %3d",sudut_servo[2]);
                ocr_servo[2]=sudut2ocr(sudut_servo[2]);
            }
            if(i==1){
                sudut_servo[2]-=1;
                if(sudut_servo[2]<0)sudut_servo[2]=180;
                sprintf(tampil,"Servo 3: %3d",sudut_servo[2]);
                ocr_servo[2]=sudut2ocr(sudut_servo[2]);
            }
            if(i==2){
                sudut_servo[3]+=1;
                if(sudut_servo[3]>180)sudut_servo[3]=0;
                sprintf(tampil,"Servo 4: %3d",sudut_servo[3]);
                ocr_servo[3]=sudut2ocr(sudut_servo[3]);
            }
            if(i==3){
                sudut_servo[3]-=1;
                if(sudut_servo[3]<0)sudut_servo[3]=180;
                sprintf(tampil,"Servo 4: %3d",sudut_servo[3]);
                ocr_servo[3]=sudut2ocr(sudut_servo[3]);
            }
            lcd_puts(tampil);
            lcd_gotoxy(12,0);
            lcd_putchar(0xDF);
            delay_ms(100);
            }
        }
        else if(kolom3==0){
            lcd_clear();
            while(kolom3==0){
            lcd_gotoxy(0,0);
            if(i==0){
                sudut_servo[4]+=1;  
                if(sudut_servo[4]>180)sudut_servo[4]=0;
                sprintf(tampil,"Servo 5: %3d",sudut_servo[4]);
                ocr_servo[4]=sudut2ocr(sudut_servo[4]);
            }
            if(i==1){
                sudut_servo[4]-=1;
                if(sudut_servo[4]<0)sudut_servo[4]=180;
                sprintf(tampil,"Servo 5: %3d",sudut_servo[4]);
                ocr_servo[4]=sudut2ocr(sudut_servo[4]);
            }
            if(i==2){
                sudut_servo[5]+=1;
                if(sudut_servo[5]>180)sudut_servo[5]=0;
                sprintf(tampil,"Servo 6: %3d",sudut_servo[5]); 
                ocr_servo[5]=sudut2ocr(sudut_servo[5]);
            }
            if(i==3){
                sudut_servo[5]-=1;
                if(sudut_servo[5]<0)sudut_servo[5]=180;
                sprintf(tampil,"Servo 6: %3d",sudut_servo[5]); 
                ocr_servo[5]=sudut2ocr(sudut_servo[5]);
            }
            lcd_puts(tampil); 
            lcd_gotoxy(12,0);
            lcd_putchar(0xDF);
            delay_ms(100);
            }
        }
        else if(kolom4==0){  
            lcd_clear();
            while(kolom4==0){
            lcd_gotoxy(0,0);
            if(i==0){
                sudut_servo[6]+=1;  
                if(sudut_servo[6]>180)sudut_servo[6]=0;
                sprintf(tampil,"Servo 7: %3d",sudut_servo[6]);
                ocr_servo[6]=sudut2ocr(sudut_servo[6]);
            }
            if(i==1){
                sudut_servo[6]-=1;
                if(sudut_servo[6]<0)sudut_servo[6]=180;
                sprintf(tampil,"Servo 7: %3d",sudut_servo[6]);
                ocr_servo[6]=sudut2ocr(sudut_servo[6]);
            }
            if(i==2){
                sudut_servo[7]+=1;
                if(sudut_servo[7]>180)sudut_servo[7]=0;
                sprintf(tampil,"Servo 8: %3d",sudut_servo[7]);
                ocr_servo[7]=sudut2ocr(sudut_servo[7]);
            }
            if(i==3){
                sudut_servo[7]-=1;
                if(sudut_servo[7]<0)sudut_servo[7]=180;
                sprintf(tampil,"Servo 8: %3d",sudut_servo[7]);
                ocr_servo[7]=sudut2ocr(sudut_servo[7]);
            }
            lcd_puts(tampil);
            lcd_gotoxy(12,0);
            lcd_putchar(0xDF);
            delay_ms(100);
            } 
        }  
//        else{
//            lcd_gotoxy(0,0);
//           lcd_puts("TIDAK TEKAN");
//        }
        header_stop=ocr_servo[0]+ocr_servo[1]+ocr_servo[2];
        header_stop+=ocr_servo[3]+ocr_servo[4]+ocr_servo[5];
        header_stop+=ocr_servo[6]+ocr_servo[7];
        header_stop=152800-header_stop;
        lcd_gotoxy(2,1);
        lcd_puts("Mengirim...");            
    }    
} 

// Timer1 output compare A interrupt service routine 
interrupt [TIM1_COMPA] void timer1_compa_isr(void){ 
switch(waktu_ke){ 
    case 0:     
        OCR1AH=header_stop>>8; 
        OCR1AL=header_stop && 0xFF; 
        waktu_ke=1;   
        break; 
    case 1:            
        OCR1AH=header_start >>8; 
        OCR1AL=header_start && 0xFF; 
        waktu_ke=2; 
        break; 
    case 2: 
        OCR1AH=ocr_servo[0] >>8; 
        OCR1AL=ocr_servo[0] && 0xFF; 
        waktu_ke=3; 
        break;  
    case 3:            
        OCR1AH=waktu_on >>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=4; 
        break; 
    case 4: 
        OCR1AH=ocr_servo[1] >>8; 
        OCR1AL=ocr_servo[1] && 0xFF; 
        waktu_ke=5; 
        break;  
    case 5:            
        OCR1AH=waktu_on >>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=6; 
        break; 
    case 6: 
        OCR1AH=ocr_servo[2] >>8; 
        OCR1AL=ocr_servo[2] && 0xFF; 
        waktu_ke=7; 
        break;  
    case 7:            
        OCR1AH=waktu_on >>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=8; 
        break; 
    case 8: 
        OCR1AH=ocr_servo[3] >>8; 
        OCR1AL=ocr_servo[3] && 0xFF; 
        waktu_ke=9; 
        break;  
    case 9:            
        OCR1AH=waktu_on >>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=10; 
        break; 
    case 10: 
        OCR1AH=ocr_servo[4] >>8; 
        OCR1AL=ocr_servo[4] && 0xFF; 
        waktu_ke=11; 
        break;  
    case 11:            
        OCR1AH=waktu_on >>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=12; 
        break; 
    case 12: 
        OCR1AH=ocr_servo[5] >>8; 
        OCR1AL=ocr_servo[5] && 0xFF; 
        waktu_ke=13; 
        break;  
    case 13:            
        OCR1AH=waktu_on >>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=14; 
        break; 
    case 14: 
        OCR1AH=ocr_servo[6] >>8; 
        OCR1AL=ocr_servo[6] && 0xFF; 
        waktu_ke=15; 
        break;  
    case 15: 
        OCR1AH=waktu_on>>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=16; 
        break; 
    case 16: 
        OCR1AH=ocr_servo[7]>>8; 
        OCR1AL=ocr_servo[7] && 0xFF; 
        waktu_ke=17; 
        break;
    case 17: 
        OCR1AH=waktu_on>>8; 
        OCR1AL=waktu_on && 0xFF; 
        waktu_ke=0; 
        break; 
} 
} 

void main(void) 
{ 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0); 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0); 

DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0); 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0); 

DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0); 
PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0); 

DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0); 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0); 

// Timer/Counter 1 initialization 
// Clock source: System Clock 
// Clock value: 8000.000 kHz 
// Mode: Normal top=0xFFFF 
// OC1A output: Clear on compare match 
// OC1B output: Clear on compare match 
// Noise Canceler: Off 
// Input Capture on Falling Edge 
// Timer Period: 2 ms 
// Output Pulse(s): 
// OC1A Period: 2 ms 
// OC1B Period: 2 ms 
// Timer1 Overflow Interrupt: On 
// Input Capture Interrupt: Off 
// Compare A Match Interrupt: Off 
// Compare B Match Interrupt: Off 
TCCR1A=(0<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (1<<COM1B0) | (0<<WGM11) | (0<<WGM10); 
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10); 
TCNT1H=0x00; 
TCNT1L=0x00; 
ICR1H=0x00; 
ICR1L=0x00; 
OCR1AH=0x00; 
OCR1AL=0x00; 
OCR1BH=0x3E; 
OCR1BL=0x80; 

// Timer(s)/Counter(s) Interrupt(s) initialization 
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0); 

// Analog Comparator initialization 
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0); 
SFIOR=(0<<ACME); 

lcd_init(16); 

// Global enable interrupts 
#asm("sei") 

sudut_servo[0]=0;
sudut_servo[1]=0;
sudut_servo[2]=0;
sudut_servo[3]=0;
sudut_servo[4]=0;
sudut_servo[5]=0;
sudut_servo[6]=0;
sudut_servo[7]=0;

ocr_servo[0]=16000;
ocr_servo[1]=16000;
ocr_servo[2]=16000;
ocr_servo[3]=16000;
ocr_servo[4]=16000;
ocr_servo[5]=16000;
ocr_servo[6]=16000;
ocr_servo[7]=16000;

while (1) 
      {  
      input_keypad_loop();            
      } 
}