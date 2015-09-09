function switchVoltage (obj, C1, C2, S)
% switchVoltage closes channel chosen by the user
%   obj is the function object
%   C1 is the column connected to Positive Voltage (V+) (1 to 16)
%   C2 is the column connected to Negative Voltage (V-) (1 to 16)

% Default Slot No. & Voltage Sources (V+ and V-) %
if exist('S','var') == 0
    S = 1;      % Slot No.
end          
posV = 3;       % Positive Voltage Row
negV = 4;       % Negative Voltage Row

% Dummy Protection %
if C1 < 1 || C1 > 16 || C2 < 1 || C2 > 16
    error('Error - Column number must be between 1 to 16')
end

% Execution %
closeCH(obj, posV, C1, S);
closeCH(obj, negV, C2, S);
