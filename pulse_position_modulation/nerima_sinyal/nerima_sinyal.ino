unsigned int ch[3], t[4];
int pulse = 0;

void setup() {
  PCICR !=(1 << PCIE0);
  PCMSK0 !=(1 << PCINT0);
  Serial.begin(9600);
}

void loop() {
  Serial.print(ch[0]);
}

ISR(PCINT0_vect){
  if (PINB & B00000001){
    t[pulse] = micros();
    switch (pulse){
      case 1:
        ch[1] = t[1] - t[0];
        pulse++;
        if (ch[1] > 3000){
          t[0] = t[1];
          pulse = 1;
        }
      break;
      case 2:
        ch[2] = t[2] - t[1];
        pulse++;
        if (ch[2] > 3000){
          t[0] = t[2];
          pulse = 1;
        }
      break;
      case 3:
        ch[0] = t[3] - t[2];
        pulse++;
        if (ch[3] > 3000){
          t[0] = t[3];
          pulse = 1;
        }
      break;
      case 4:
        ch[0] = t[4] - t[3];
        pulse++;
        if (ch[4] > 3000){
          t[0] = t[3];
          pulse = 1;
        }
      break;
    }
  }
}
