#include <Stepper.h>
#include <Servo.h>
const int stepsPerRevolution = 200;
const int ButtonPin = 6;
int ButtonState = 0;
int arr[6] = {0, 0, 0, 0, 0, 0};
String input = "привет мир";
int Lngth = input.length();
int pos = 0;
Servo row1, row2, row3;
Stepper myStepper(stepsPerRevolution, 4, 5, 8, 7);
void setup() {
  myStepper.setSpeed(60);
  Serial.begin(9600);
  row1.attach (1);
  row2.attach (2);
  row3.attach (3);
   row1.write (0);
    for (pos = 0; pos <= 180; pos += 1) {
      row1.write(pos);
      delay(15);
    }
    for (pos = 180; pos >= 0; pos -= 1) {
      row1.write(pos);
      delay(15);
    }
}

void loop() {

  ButtonState = digitalRead(ButtonPin);
  if (ButtonState == HIGH) {
   
    Serial.println("clockwise");
    myStepper.step(stepsPerRevolution);
    delay(500);
  }

}
void charToBraille (int i) {
  if (input.charAt(i)  == "а") {
    arr[0] = 1;
  }
  if (input.charAt(i)  == "б") {
    arr[0] = 1;
    arr[1] = 1;
  }
  if (input.charAt(i)  == "в") {
    arr[1] = 1;
    arr[3] = 1;
    arr[4] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "г") {
    arr[0] = 1;
    arr[1] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "д") {
    arr[0] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "е") {
    arr[0] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "ж") {
    arr[1] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "з") {
    arr[0] = 1;
    arr[2] = 1;
    arr[4] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "и") {
    arr[1] = 1;
    arr[3] = 1;
  }
  if (input.charAt(i)  == "й") {
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "к") {
    arr[0] = 1;
    arr[2] = 1;
  }
  if (input.charAt(i)  == "л") {
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 1;
  }
  if (input.charAt(i)  == "м") {
    arr[0] = 1;
    arr[2] = 1;
    arr[3] = 1;
  }
  if (input.charAt(i)  == "н") {
    arr[0] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "о") {
    arr[0] = 1;
    arr[2] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "п") {
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 1;
    arr[3] = 1;
  }
  if (input.charAt(i)  == "р") {
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "с") {
    arr[1] = 1;
    arr[2] = 1; //точно ли? встречал другое
    arr[3] = 1;
  }
  if (input.charAt(i)  == "т") {
    arr[1] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "у") {
    arr[0] = 1;
    arr[2] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "ф") {
    arr[0] = 1;
    arr[1] = 1;
    arr[3] = 1;
  }
  if (input.charAt(i)  == "х") {
    arr[0] = 1;
    arr[1] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "ц") {
    arr[0] = 1;
    arr[3] = 1;
  }
  if (input.charAt(i)  == "ч") {
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[4] = 1;
  }
  if (input.charAt(i)  == "ш") {
    arr[0] = 1;
    arr[4] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "щ") {
    arr[0] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "ъ") {
    arr[0] = 1;
    arr[1] = 1;
    arr[2] = 1;
    arr[4] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "ы") {
    arr[1] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "ь") {
    arr[1] = 1;
    arr[2] = 1;
    arr[3] = 1;
    arr[4] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "э") {
    arr[1] = 1;
    arr[3] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "ю") {
    arr[0] = 1;
    arr[1] = 1;
    arr[4] = 1;
    arr[5] = 1;
  }
  if (input.charAt(i)  == "я") {
    arr[0] = 1;
    arr[1] = 1;
    arr[3] = 1;
    arr[5] = 1;
  }

}
