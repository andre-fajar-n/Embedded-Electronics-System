unsigned long counter_1,current_count;
byte last_CH1_state;
int Ch1;
int pulsa[9];
int i=0;
int a=0;

void setup() {
  PCICR |= 0b00000100;    //enable PCMSK0 scan                                                 
  PCMSK2 |= (1 << PCINT20);  //Set pin D4 PD4trigger an interrupt on state change.                                                
  Serial.begin(9600);  
}

void loop() {
  for(a=1;a<9;a++){
     Serial.print(pulsa[a]);
     Serial.print("\t");
  }
  Serial.print("\n");
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
    }
    else{
      pulsa[i] = Ch1;
    }
  } 
}
