#Same as piconnection code but looking for an arrray from MATLAB
#Be sure to reset mbed and wait for thruster sound to run code
import socket
import sys
import struct
import time
import serial

##UDP Setup
UDP_IP = "169.254.132.47"#PC's IP Address
UDP_PORT = 6793 #PC's local port
# Create a UDP Socket
sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
# Bind the socket to the port
sock.bind(('', 8000)) #PC's Remote Port Number, Can be same between PC and Pi
print("UDP Server up and listening")

#Serial Setup
ser = serial.Serial(
    port="/dev/ttyACM0",
    baudrate=115200)
print(ser.name)

dt = 0.1 #wait time

#Wait for 123, send back 123
check = sock.recvfrom(1024)
check1 = check[0].decode('ASCII')
print("received message:", check[0])
print("received message:", check1)
sock.sendto(check[0], (UDP_IP, UDP_PORT))
#sock.settimeout(3)

while True:
    #Read 3 floats, send floats to mbed, read 1 signal float from mbed and send back to matlab
    array = sock.recv(1024)
    array1 = array.decode('ASCII')
    print(array1)
    heading = array1[5:10]
    print('desired heading:', heading)
    depth = array1[18:21]
    print('desired depth:', depth)
    signal = array1[30:33]
    print('key signal:', signal)
    #sock.sendto(signal[0], (UDP_IP, UDP_PORT)) #test to see if pi got correct signal
    #print("signal sent")
    #Convert all float values from PC to strings. In quotes is what mbed is looking for to start reading, then str() turns data in that variable to string
    strheading = 'HeadingFromPC' + str(heading)
    strdepth = 'DepthFromPC' + str(depth)
    strsignal = 'CommandFromPC' + str(signal)
    #.encode converts strings to bytes, which are then sent to mbed
    #print("data converted")
    ser.write(strheading.encode('UTF-8'))
    print(strheading.encode('UTF-8'))
    ser.write(strdepth.encode('UTF-8'))
    ser.write(strsignal.encode('UTF-8'))
    print("data sent to mbed")
    #print(strsignal.encode('UTF-8'))
    #read and print what the mbed sends back to pi
    #thrustback1 = ser.readline()
    #print(thrustback1) #What is it sending???
    #thrustback2 = ser.readline()
    #print(thrustback2)
    #thrustback3 = ser.readline()
    #print(thrustback3)

    time.sleep(dt)
    

