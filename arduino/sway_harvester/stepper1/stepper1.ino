#include <Stepper.h>
bool flag;
const int stepsPerRevolution = 2000;

// initialize the stepper library on pins 8 through 11:
int in1=8, in2=9, in3=10, in4=11;
Stepper myStepper(stepsPerRevolution, in1, in3, in2, in4);

void setup() {
  // set the speed at 6 rpm:
  myStepper.setSpeed(6); //stepsPerRevolution*speed should be 12000
  pinMode(13,INPUT);
  //Serial.begin(9600);
}

void loop() {
  
  if (!flag){
  myStepper.step(stepsPerRevolution/5);
  }
  else{
  myStepper.step(-stepsPerRevolution/5);
  }
  if(digitalRead(13)==HIGH){
    flag=true;
  }
  else{
    flag=false;
  }
}

