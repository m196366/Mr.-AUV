#Code to test pi to mbed connection without MATLAB
import serial
import struct
import time
ser = serial.Serial(
    port="/dev/ttyACM0",
    baudrate=9600)
print(ser.name)

#Given values from PC
HeadingFromPC = 90
DepthFromPC = 2
CommandFromPC = 1
dt = 0.5 #sleep time

#Convert all float values from PC to strings. In quotes is what mbed is looking for to start reading, then str() turns data in that variable to string
strheading = 'HeadingFromPC' + str(HeadingFromPC)
strdepth = 'DepthFromPC' + str(DepthFromPC)
strcommand = 'CommandFromPC' + str(CommandFromPC)

while True:
    #.encode converts strings to bytes, which are then sent to mbed
    #ser.write(strheading.encode('UTF-8'))
    #ser.write(strdepth.encode('UTF-8'))
    ser.write(strcommand.encode('UTF-8'))
    print(strcommand.encode('UTF-8'))

    #read and print what the mbed sends back to pi
    #thrustback1 = ser.readline()
    #print(thrustback1)
    #thrustback2 = ser.readline()
    #print(thrustback2)
    #thrustback3 = ser.readline()
    #print(thrustback3)
    time.sleep(dt)
