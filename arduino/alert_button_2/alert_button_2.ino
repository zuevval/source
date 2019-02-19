#include "pitches.h"
const int Speaker_pin = 13;
const int button_pin = 12;
unsigned long interval=1500;
unsigned long currentMillis=0;
unsigned long reachMillis=interval;

void setup() {
  Serial.begin(9600);
  pinMode(button_pin, INPUT);
}

void loop() {
  //Serial.print("0");
  currentMillis=millis();
  if(reachMillis-currentMillis > interval){
    reachMillis = currentMillis+interval;
    noTone(Speaker_pin);
    tone(Speaker_pin, NOTE_G3, 250);
  }
  if(digitalRead(button_pin)==LOW){
    noTone(Speaker_pin);
    //Serial.print("1");
    alert();
  }
}

void alert(){
  while(1==1){
    tone(Speaker_pin, NOTE_B4, 500);
    delay(500);
    noTone(Speaker_pin);
    tone(Speaker_pin, NOTE_C4, 500);
    delay(500);
    noTone(Speaker_pin);
    delay(125);
  }
}
