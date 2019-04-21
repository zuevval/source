#!/usr/bin/env python
import RPi.GPIO as GPIO
import time
PIN_NUM = 7
 
GPIO.setmode(GPIO.BOARD)
GPIO.setup(PIN_NUM,GPIO.OUT)
for i in range(10):
    GPIO.output(PIN_NUM,True)
    print("ON")
    time.sleep(1)
    GPIO.output(PIN_NUM,False)
    print("OFF")
    time.sleep(1)
