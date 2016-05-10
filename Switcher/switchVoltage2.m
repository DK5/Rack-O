function switchVoltage2 (obj, str, C1, C2, S)
% switchVoltage closes channel chosen by the user
%   obj is the function object
%   C1 is the column connected to Positive Voltage (V+) (3 to 14)
%   C2 is the column connected to Negative Voltage (V-) (3 to 14)
%   str - 'ON' closes CH ; 'OFF' opens CH

% Default Slot No. & Voltage Sources (V+ and V-) %
if exist('S','var') == 0
    S = 1;      % Slot No.
end

ExtraInstrument(obj,'V','ON')
posV = 5;       % Positive Voltage Row
negV = 6;       % Negative Voltage Row

% Dummy Protection %
if C1 < 3 || C1 > 14 || C2 < 3 || C2 > 14
    error('Error - Column number must be between 3 to 14');
end

% Execution %
switch upper(str)
    case 'ON'
        closeCH(obj, posV, C1, S);
        closeCH(obj, negV, C2, S);
    case 'OFF'
        openCH(obj, posv, C1, S);
        openCH(obj, negV, C2, S);
end