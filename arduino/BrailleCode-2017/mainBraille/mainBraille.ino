
#include <Servo.h>
#include <Stepper.h>
//#include <EEPROM.h>

#define NON_BRAILLE 0x40
#define STEPS 64
#define SERVO_PIN1 9
#define SERVO_PIN2 2
#define SERVO_PIN3 3
#define STEPPER_PIN1 4
#define STEPPER_PIN2 8
#define STEPPER_PIN3 5
#define STEPPER_PIN4 7
#define BUTTON_PIN 6

Servo row1, row2, row3;
Stepper stp = Stepper(STEPS, STEPPER_PIN1, STEPPER_PIN2, STEPPER_PIN3, STEPPER_PIN4);

void setup() {
  Serial.begin(9600);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  stp.setSpeed(300);
  row1.attach (SERVO_PIN1);
  row2.attach (SERVO_PIN2);
  row3.attach (SERVO_PIN3);
  row1.write(0);
  row2.write(0);
  row3.write(0);
}

void loop() {
  char c = Serial.read();
  if(c != -1){//если с компьютера поступила новая буква
    Serial.print("new letter: ");
    Serial.print(c);
    if(charToBraille(c) == NON_BRAILLE){
      Serial.println(" error translating symbol");
    } else {
      while(digitalRead(BUTTON_PIN) == LOW){//ждем пока кнопка не будет отпущена
        stp.step(10);//вращаем основной барабан
        delay(10);
      }
      Serial.println();
      Serial.print("printing the letter: ");
      Serial.print(c);
      putOut(charToBraille(c));//выводим букву
      Serial.println(" end printing");
    }
  }
  delay(10);//просто ждем
}

void putOut(char brailleCh){
  brailleCh = ~brailleCh;
  int num = 45;
  if (brailleCh & 0x01) row1.write (num);
  if (brailleCh & 0x02) row2.write (num);
  if (brailleCh & 0x04) row3.write (num);
  delay(1000);
  row1.write (0);
  row2.write (0);
  row3.write (0);
  delay(1000);
  stp.step(200);
  if (brailleCh & 0x08) row1.write (num);
  if (brailleCh & 0x10) row2.write (num);
  if (brailleCh & 0x20) row3.write (num);
  delay(1000);
  row1.write (0);
  row2.write (0);
  row3.write (0);
  delay(1000);
}

/* новая версия
char charToBraille (char original) {
  char c;
  for(int i = 0; i<EEPROM.length(); i+=2){
    c = EEPROM.read(i);
    if(c == NON_BRAILLE) break;
    if(c == original) return EEPROM.read(i + 1);
  }
  return NON_BRAILLE;
}
*/

//старая версия
char charToBraille (char c) {
  char b = 0x00;
  switch(c){
    case 'a':
    case 'b':
    case 'c':
    case 'd':
    case 'e':
    case 'f':
    case 'g':
    case 'h':
    case 'k':
    case 'l':
    case 'm':
    case 'n':
    case 'o':
    case 'p':
    case 'q':
    case 'r':
    case 'u':
    case 'v':
    case 'x':
    case 'y':
    case 'z':
    b |= 0x01;
    break;
  }
  switch(c){
    case 'b':
    case 'f':
    case 'g':
    case 'h':
    case 'i':
    case 'j':
    case 'l':
    case 'p':
    case 'q':
    case 'r':
    case 's':
    case 't':
    case 'v':
    case 'w':
    b |= 0x02;
    break;
  }
  switch(c){
    case 'k':
    case 'l':
    case 'm':
    case 'n':
    case 'o':
    case 'p':
    case 'q':
    case 'r':
    case 's':
    case 't':
    case 'u':
    case 'v':
    case 'x':
    case 'y':
    case 'z':
    case 'w':
    b |= 0x04;
    break;
  }
  switch(c){
    case 'c':
    case 'd':
    case 'f':
    case 'g':
    case 'i':
    case 'j':
    case 'm':
    case 'n':
    case 'p':
    case 'q':
    case 's':
    case 't':
    case 'x':
    case 'y':
    case 'w':
    b |= 0x08;
    break;
  }
  switch(c){
    case 'd':
    case 'e':
    case 'g':
    case 'h':
    case 'j':
    case 'n':
    case 'o':
    case 'q':
    case 'r':
    case 't':
    case 'y':
    case 'z':
    case 'w':
    b |= 0x10;
    break;
  }
  switch(c){
    case 'u':
    case 'v':
    case 'x':
    case 'y':
    case 'z':
    case 'w':
    b |= 0x20;
    break;
  }
 return b;
}
