function ser = SerialInit(COM,baud)
%This function opens a serial port with object name ser on the com port
%named COM

%   Inputs: COM: a string specifying the com port associated with the
%   device
%   baud: the necessary baud rate for the communication with the device

%   Output: ser: a MATLAB serial object

%   Written by: MIDN 3/C Xebastian Aguilar, USN 1/31/2017

%% close any open serial ports

a = instrfindall; % find all serial objects that exist on the machine

if isempty(a)==0 % If the instrument search reveals a port is open
    % If the port is being used, close and delete it
    fclose(a); % close serial port connection
    delete(a); % delete serial object
    clear a % clear serial object variable
end

ser = serial(COM); % creates serial object

set(ser,'BaudRate',baud);   % specified baud rate bits/s
set(ser,'Parity','None');   % no parity error checking
set(ser,'Terminator','LF'); % line feed terminator
set(ser,'StopBits',1);  % 1 stop bit
set(ser,'Timeout',.5);  % timeout as .5 s
set(ser,'FlowControl','None');  % no flow control

fopen(ser); % open serial port named ser
end

