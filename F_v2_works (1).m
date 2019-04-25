%% Open serial port
clear all; close all; clc
COM = 'COM3';
baud = 115200;
ser = SerialInit(COM,baud);

%% Send signals
% This reads the w,a,s,d keyboard input and runs the motor forward and
% reverse and stops when no button is being pressed.

% establish connection with serial
state = 123;
check = 0;
%fprintf(ser,'%d\n',state,'async');
%check = fscanf(ser,'%d');

% if check == 123
%     fprintf('Thruster is Initialized\n');
% else
%     fprintf('Thruster is not Initialized\n');
% end

% User input desired heading
% Eventually, this will be read from user from RaspPi
Hdes = input('Desired heading in degrees\n'); % desired Heading
Ddes = input('Desired depth in feet\n'); % desired Depth

% Waypoint Data
% WayPts = 1;
% WayPtData = ...
%     [0 0 5;
%     5 0 5;
%     5 5 5;
%     0 5 5;
%     0 0 5];

fig=figure(1); clf
% states
fig.UserData.F = 0;
fig.UserData.R = 0;
fig.UserData.Rt = 0;
fig.UserData.Lt = 0;
fig.UserData.A = 0;
fig.UserData.D = 0;
fig.UserData.Quit = 0;
fig.UserData.Reset = 0;
title('Teleoperate MR. AUV');

%gives handle for axes so that if figure is exited, it does not reappear
ax = gca;
ax.DataAspectRatio = [1 1 1];
ax.Position = [0 0 1 1];
fig.KeyPressFcn = @keypressed; % add key pressed callback to listen for l-r-spc
hold on;

dt = 0.1;
i=1;
%
p1=0; % forward
p2=0; % reverse
p3=0; % left turn
p4=0; % right turn
p5=0; % ascend
p6=0; % descend
p7=0; % quit break loop
p8=0; % reset mbed
%
fp1=0; % forward
fp2=0; % reverse
fp3=0; % left turn
fp4=0; % right turn
fp5=0; % ascend
fp6=0; % descend
fp7=0; % quit break loop
fp8=0; % reset mbed
%
signal(1) = 0;


while 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % NOTE: All of these sections below use the same logic.
    % When you first press a key on the keyboard, MATLAB reads a 1 and then
    % 3 or 4 consecutive zeroes before the value stays 1 for as long as the
    % keyboard is pressed.
    % The variable t1,t2,t3...
    % is to see when the key was pressed for plotting purposes later.
    % Both Thrusters FORWARD
    if fig.UserData.F == 1
        fp1 = 1; % turn on full press
        p1 = p1+1; % increment 4 values until press registered
        if p1>4 % When the code getes into this loop, the command value is actually set to its corresponding value.
            signal = 1; % The variable signal is the actual command.
            t1(i) = 1; % The variable t1,t2,t3... is to see when the key was pressed for plotting purposes later.
        end
        t1(i) = 1;
        fig.UserData.F = 0;
    elseif (fp1==1)&&(p1<=4) % runs through 4 iterations before actually setting the value
        p1 = p1+1;
        t1(i) = 1;
    elseif (p2>4) || (p3>4) || (p4>4) || (p5>4) || (p6>4) || (p7>4) || (p8>4)
        % If other keys are pressed, make this key a 0.
        t1(i) = 0;
        fp1=0;
        p1=0;
    else
        signal = 0;
        t1(i)=0;
        fp1=0;
        p1=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Both Thrusters REVERSE
    if fig.UserData.R == 1
        fp2 = 1;
        p2 = p2+1;
        if p2>4
            signal = -1;
            t2(i) = -1;
        end
        t2(i)=-1;
        fig.UserData.R = 0;
    elseif (fp2==1)&&(p2<=4)
        p2=p2+1;
        t2(i) = -1;
    elseif (p1>4) || (p3>4) || (p4>4) || (p5>4) || (p6>4) || (p7>4) || (p8>4)
        t2(i) = 0;
        fp2=0;
        p2=0;
    else
        signal = 0;
        t2(i)=0;
        fp2=0;
        p2=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Right Turn
    if fig.UserData.Rt == 1
        fp3 = 1;
        p3 = p3+1;
        if p3>4
            signal = 3;
            t3(i) = 3;
        end
        t3(i)=3;
        fig.UserData.Rt = 0;
    elseif (fp3==1)&&(p3<=4)
        p3=p3+1;
        t3(i) = 3;
    elseif (p1>4) || (p2>4) || (p4>4) || (p5>4) || (p6>4) || (p7>4) || (p8>4)
        t3(i) = 0;
        fp3=0;
        p3=0;
    else
        signal = 0;
        t3(i)=0;
        fp3=0;
        p3=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Left Turn
    if fig.UserData.Lt == 1
        fp4 = 1;
        p4 = p4+1;
        if p4>4
            signal = -3;
            t4(i) = -3;
        end
        t4(i)=-3;
        fig.UserData.Lt = 0;
    elseif (fp4==1)&&(p4<=4)
        p4=p4+1;
        t4(i) = -3;
    elseif (p1>4) || (p2>4) || (p3>4) || (p5>4) || (p6>4) || (p7>4) || (p8>4)
        t4(i) = 0;
        fp4=0;
        p4=0;
    else
        signal = 0;
        t4(i)=0;
        fp4=0;
        p4=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Ascend
    if fig.UserData.A == 1
        fp5 = 1;
        p5 = p5+1;
        if p5>4
            signal = 5;
            t5(i) = 5;
        end
        t5(i)=5;
        fig.UserData.A = 0;
    elseif (fp5==1)&&(p5<=4)
        p5=p5+1;
        t5(i) = 5;
    elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p6>4) || (p7>4) || (p8>4)
        t5(i) = 0;
        fp5=0;
        p5=0;
    else
        signal = 0;
        t5(i)=0;
        fp5=0;
        p5=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Descend
    if fig.UserData.D == 1
        fp6 = 1;
        p6 = p6+1;
        if p6>4
            signal = -5;
            t6(i) = -5;
        end
        t6(i)=-5;
        fig.UserData.D = 0;
    elseif (fp6==1)&&(p6<=4)
        p6=p6+1;
        t6(i) = -5;
    elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p5>4) || (p7>4) || (p8>4)
        t6(i) = 0;
        fp6=0;
        p6=0;
    else
        signal = 0;
        t6(i)=0;
        fp6=0;
        p6=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   
    % Quit Break Loop
    % When this command is run, Mbed stops all motors and sets the
    % direction of the vertical motor UP so that it can surface as quickly
    % as possible.
    if fig.UserData.Quit == 1
        fp7 = 1;
        p7 = p7+1;
        if p7>4
            signal = 11;
            t7(i) = 11;
        end
        t7(i)=11;
        fig.UserData.Quit = 0;
    elseif (fp7==1)&&(p7<=4)
        p7=p7+1;
        t7(i) = 11;
    elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p5>4) || (p6>4) || (p8>4)
        t7(i) = 0;
        fp7=0;
        p7=0;
    else
        signal = 0;
        t7(i)=0;
        fp7=0;
        p7=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   
    % Reset Mbed
    if fig.UserData.Reset == 1
        fp8 = 1;
        p8 = p8+1;
        if p8>4
            signal = 123;
            t8(i) = 123;
        end
        t8(i)=123;
        fig.UserData.Reset = 0;
    elseif (fp8==1)&&(p8<=4)
        p8=p8+1;
        t8(i) = 123;
    elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p5>4) || (p6>4) || (p7>4)
        t8(i) = 0;
        fp8=0;
        p8=0;
    else
        signal = 0;
        t8(i)=0;
        fp8=0;
        p8=0;
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % update
    array = [Hdes Ddes signal]; % this updates the array to send to Mbed
    fprintf(ser,'%f %f %f\n',array,'async');
    rtrn = fscanf(ser,'%f') % this is just meant to read what command value was sent to the mbed
    if (rtrn==123) % This is the command value to reset the Mbed
        pause(4)
    end
    
    i=i+1;
    pause(dt)
end

%% Plot
% This can be used to plot any of the values versus iteration to see what
% is going on and what keys are being pressed.

figure(10); clf
x = 1:length(t1);
plot(x,t1)
hold on
plot(x,t2)
hold on
plot(x,t3)
hold on
plot(x,t4)
hold on
plot(x,t5)
hold on
plot(x,t6)
hold on
plot(x,t7)
hold on
plot(x,t8)

% legend('t1','signal','t2')