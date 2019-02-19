#include<Wire.h>
#include<LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 2, 1, 0, 4, 5, 6, 7, 3, POSITIVE); 

void setup() {
  lcd.begin(16,2); //Defining 16 columns and 2 rows of lcd display
  lcd.backlight(); //To Power ON /OFF the back light
  lcd.setCursor(0,0); //Defining positon to write from first row,first column .
  lcd.setCursor(0,1); //Defining positon to write from second row,first column .
  lcd.print(" write here to print"); //You can write 16 Characters per line within quotations.
  delay(1000);
  lcd.clear(); //Clean the screen
}

void loop() {
  // put your main code here, to run repeatedly:

}
