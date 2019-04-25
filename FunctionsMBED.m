%% UDP Connection from MATLAB to Pi
%Must have at least MATLAB2018b!!
u = udp('169.254.230.26','RemotePort',8000,'LocalPort',6793);%(Pi's IP adress,Any open port number(can be same as Pi),PC's port number(Different than UDP_PORT in Pi code))
fopen(u); %opens connection to UDP object

%% ensure established connection with udp
state = 123;
check = 0;
fprintf(u,'%d',state);
check = fscanf(u);

if check == '123'
    fprintf('Thruster is Initialized\n');
else
    fprintf('Thruster is not Initialized\n');
end


% This reads the w,a,s,d keyboard input and runs the motor forward and
% reverse and stops when no button is being pressed.
% User input desired heading
% Eventually, this will be read from user from RaspPi
Hdes = input('Desired heading in degrees\n'); % desired Heading, must be 3 digits
Ddes = input('Desired depth in feet\n'); % desired Depth, single digit number

fig=figure(1); clf
% states
fig.UserData.F = 0;
fig.UserData.R = 0;
fig.UserData.Rt = 0;
fig.UserData.Lt = 0;
fig.UserData.Vu = 0;
fig.UserData.Vd = 0;
fig.UserData.A = 0;
fig.UserData.D = 0;
title('Teleoperate MR. AUV');

%gives handle for axes so that if figure is exited, it does not reappear
ax = gca;
ax.DataAspectRatio = [1 1 1];
ax.Position = [0 0 1 1];
fig.KeyPressFcn = @keypressed; % add key pressed callback to listen for l-r-spc
hold on;

dt = 0.05;
i=1;
%
p1=0; % forward
p2=0; % reverse
p3=0; % left turn
p4=0; % right turn
p5=0; %ascend
p6=0; %descend
%
fp1=0; % forward
fp2=0; % reverse
fp3=0; % left turn
fp4=0; % right turn
fp5=0; %ascend
fp6=0; %descend
%
signal(1) = 0;


while 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Both Thrusters FORWARD
    if fig.UserData.F == 1
        fp1 = 1; % turn on full press
        p1 = p1+1; % increment 4 values until press registered
        if p1>4
            signal = 1;
            t1(i) = 1;
        end
        t1(i) = 1;
        fig.UserData.F = 0;
    elseif (fp1==1)&&(p1<=4)
        p1 = p1+1;
        t1(i) = 1;
    elseif (p2>4) || (p3>4) || (p4>4)
        t1(i) = 0;
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
    elseif (p1>4) || (p3>4) || (p4>4)
        t2(i) = 0;
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
    elseif (p1>4) || (p2>4) || (p4>4)
        t3(i) = 0;
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
    elseif (p1>4) || (p2>4) || (p3>4)
        t4(i) = 0;
    else
        signal = 0;
        t4(i)=0;
        fp4=0;
        p4=0;
    end
    
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
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
    elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p6>4)
        t5(i) = 0;
    else
        signal = 0;
        t5(i)=0;
        fp5=0;
        p5=0;
    end
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
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
    elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p5>4)
        t6(i) = 0;
    else
        signal = 0;
        t6(i)=0;
        fp6=0;
        p6=0;
    end
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
    % Stop all thrusters
%     if fig.UserData.S == 1
%         fp7 = 1;
%         p7 = p7+1;
%         if p7>4
%             signal = -7;
%             t7(i) = -7;
%         end
%         t7(i)=-7;
%         fig.UserData.D = 0;
%     elseif (fp7==1)&&(p7<=4)
%         p7=p7+1;
%         t7(i) = -7;
%     elseif (p1>4) || (p2>4) || (p3>4) || (p4>4) || (p5>4)
%         t7(i) = 0;
%     else
%         signal = 0;
%         t7(i)=0;
%         fp7=0;
%         p7=0;
%     end
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Be sure to reset mbed before running pi code
    % update
%     array = [Hdes Ddes signal];
%     fprintf(u,'head:%.1f, depth:%.1f, signal:%.1f', array);
     fprintf(u,'%.1f',Hdes);
     fprintf(u,'%.1f',Ddes);
     fprintf(u,'%.1f',signal);
    %cmdddd = fscanf(u);%makes sure signal was sent
    
    
    i=i+1;
    pause(dt)
end
%% Close UDP Port
fclose(u)
delete(u)
clear u