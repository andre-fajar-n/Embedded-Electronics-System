#include <Servo.h> 

Servo channel1; 
Servo channel2; 
Servo channel3; 
Servo channel4; 
Servo channel5; 
Servo channel6; 
Servo channel7; 
Servo channel8; 

unsigned long counter_1,current_count; 
byte last_CH1_state; 
int Ch1; 
int pulsa[9],servo[9]; 
int i=0; 
int a=0; 

void setup() {   
  PCICR |= 0b00000100;    //enable PCMSK0 scan                                                  
  PCMSK2 |= (1 << PCINT20);  //Set pin D4 PD4trigger an interrupt on state change.   
  channel1.attach(3); 
  channel2.attach(5); 
  channel3.attach(6); 
  channel4.attach(9); 
  channel5.attach(10); 
  channel6.attach(11); 
  channel7.attach(3); 
  channel8.attach(3); 
  Serial.begin(9600);   
   
} 

void loop() { 
 for(a=1;a<9;a++){ 
    Serial.print(pulsa[a]); 
    Serial.print("\t"); 
  }

  Serial.print("\n"); 
  servo[1]=map(pulsa[1],1000,2000,0,180); 
  servo[2]=map(pulsa[2],1000,2000,0,180); 
  servo[3]=map(pulsa[3],1000,2000,0,180); 
  servo[4]=map(pulsa[4],1000,2000,0,180); 
  servo[5]=map(pulsa[5],1000,2000,0,180); 
  servo[6]=map(pulsa[6],1000,2000,0,180); 
  servo[7]=map(pulsa[7],1000,2000,0,180); 
  servo[8]=map(pulsa[8],1000,2000,0,180); 

  channel1.write(servo[1]); 
  channel2.write(servo[2]); 
  channel3.write(servo[3]); 
  channel4.write(servo[4]); 
  channel5.write(servo[5]); 
  channel6.write(servo[6]); 
  channel7.write(servo[7]); 
  channel8.write(servo[8]); 
  delay(15);
} 

//This is the interruption routine 
//---------------------------------------------- 

ISR(PCINT2_vect){ 
//First we take the current count value in micro seconds using the micros() function 
   
  current_count = micros(); 
  ///////////////////////////////////////Channel 1 
   
  if(PIND & B00010000){                              //PD4 
    if(last_CH1_state == 0){                         //If the last state was 0, then we have a state change... 
      last_CH1_state = 1;                            //Store the current state into the last state for the next loop 
      counter_1 = current_count;                     //Set counter_1 to current value. 
    } 
  } 
  else if(last_CH1_state == 1){                      //If pin 8 is LOW and the last state was HIGH then we have a state change       
    last_CH1_state = 0;                              //Store the current state into the last state for the next loop 
    i++; 
    Ch1 = current_count - counter_1;                //We make the time difference. Channel 1 is current_time - timer_1. 

    if(Ch1 >2000){     
      pulsa[0] = Ch1; 
      i=0; 
    } else {
      pulsa[i] = Ch1; 
    }
  } 
}
