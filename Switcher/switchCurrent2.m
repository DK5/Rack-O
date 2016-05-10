function switchCurrent2 (obj, str, C1, C2, S)
% switchCurrent closes channel chosen by the user
%   obj is the function object
%   C1 is the column connected to Positive Current (I+) (3 to 14)
%   C2 is the column connected to Negative Current (I-) (3 to 14)
%   str - 'ON' closes CH ; 'OFF' opens CH

% Default Slot No. & Current Sources (I+ and I-) %
if exist('S','var') == 0
    S = 1;      % Slot No.
end

ExtraInstrument(obj,'I','ON')
posI = 5;       % Positive Current Row
negI = 6;       % Negative Current Row

% Dummy Protection %
if C1 < 3 || C1 > 14 || C2 < 3 || C2 > 14
    error('Error - Column number must be between 3 to 14');
end

% Execution %
switch upper(str)
    case 'ON'
        closeCH(obj, posI, C1, S);
        closeCH(obj, negI, C2, S);
    case 'OFF'
        openCH(obj, posI, C1, S);
        openCH(obj, negI, C2, S);
end
