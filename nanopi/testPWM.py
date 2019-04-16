import os
import sys
from pyA20.gpio import gpio
from pyA20.gpio import port
#from pyA20.i2c  import i2c
import Adafruit_GPIO.I2C as I2C

import board
#import busio
#from busio import *
from adafruit_servokit import ServoKit
#kit = ServoKit(channels=16, i2c=(busio.I2C(board.SCL, board.SDA)))
#kit = ServoKit(channels=16, i2c=(busio.I2C(port.PA11, port.PA12)))
#i2c = I2C(port.PA11, port.PA12);
#i2c1 = I2C(port.PA11, port.PA12);
i2c1 = I2C
kit = ServoKit(channels=16, i2c=i2c1)
