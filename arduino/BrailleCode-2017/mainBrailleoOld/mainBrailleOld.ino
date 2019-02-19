#include <Servo.h>
Servo main;
int posm = 0;
Servo row1, row2, row3;
const int ButtonPin = 5;
int ButtonState = 0;
int arr[6] = {0, 0, 0, 0, 0, 0};
String input = "привет мир";
int Lngth = input.length();
void setup() {
  main.attach (4);
  row1.attach (1);
  row2.attach (2);
  row3.attach (3);

}

void loop() {
  ButtonState = digitalRead (ButtonPin);
  row1.write (0);
  row2.write (0);
  row3.write (0);
  if (ButtonState == LOW) {
    while (ButtonState != HIGH) {
      posm = posm + 1;
      main.write (posm);
      delay (5);
      ButtonState = digitalRead (ButtonPin);
    }
  }
  for (int i = 0; i <= Lngth; i++) {
    charToBraille (i);
    if (arr[0] == 0)
      row1.write (10); //для примера, число нужно подбирать
    if (arr[1] == 0)
      row2.write (10);
    if (arr[2] == 0) {
      row3.write (10);
    }
    delay(10);
    row1.write (0);
    row2.write (0);
    row3.write (0);
    posm = posm + 20; //наверное, чуть меньше
    if (arr[3] == 0)
      row1.write (10); //для примера, число нужно подбирать
    if (arr[4] == 0)
      row2.write (10);
    if (arr[5] == 0) {
      row3.write (10);
    }
    delay(10);
    row1.write (0);
    row2.write (0);
    row3.write (0);
    while (ButtonState != HIGH) {
      posm = posm + 1; // Для скорости вначале просто переместить на 10-15 (?)
      main.write (posm);
      delay (5);
      ButtonState = digitalRead (ButtonPin);
    }
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
