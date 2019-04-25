function keypressed(figObject, eventdata)

% disp(eventdata.Key)

switch eventdata.Key
    case 'w'
        figObject.UserData.F = 1; % forward
    case 's'
        figObject.UserData.R = 1; % reverse
    case 'a'
        figObject.UserData.Lt = 1; % left turn
    case 'd'
        figObject.UserData.Rt = 1; % right turn
    case 'e'
        figObject.UserData.A = 1; % vertical up
    case 'q'
        figObject.UserData.D = 1; % vertical down
end
end