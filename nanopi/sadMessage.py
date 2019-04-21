#!/usr/bin/env python3.5
import os
import sys

if not os.getegid() == 0:
    sys.exit('Script must be run as root')

from time import sleep
from pyA20.gpio import gpio
from pyA20.gpio import connector
from pyA20.gpio import port

#led = port.STATUS_LED
led = port.PA13
#button = port.PL3
button = port.PG11

"""Init gpio module"""
gpio.init()

"""Set directions"""
gpio.setcfg(led, gpio.OUTPUT)
gpio.setcfg(button, gpio.INPUT)

"""Enable pullup resistor"""
gpio.pullup(button, gpio.PULLUP)
#gpio.pullup(button, gpio.PULLDOWN)     # Optionally you can use pull-down resistor
state =1
value_out = 1
phrases = ["!привет, я NanoPi Duo", "!когда-нибудь я буду использован в проекте Тренажёр Брайля", "!но уже не в рамках курса Основы Проектной Деятельности"]
i=0
try:
    print ("Press CTRL+C to exit")
    while True:
        """Since we use pull-up the logic will be inverted"""
        gpio.output(led,  value_out)
        sleep(0.1)
        state = gpio.input(button)      # Read button state
        if state &(value_out == 0):
            value_out = 1;
            gpio.output(led,  value_out)
            if i < len(phrases):
                print(phrases[i])
                signal_string = input()
                i+=1
        else:
            value_out = 0;
        sleep(0.1)
        
       

except KeyboardInterrupt:
    print ("Goodbye.")
