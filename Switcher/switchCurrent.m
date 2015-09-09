function switchCurrent (obj, C1, C2, S)
% switchCurrent closes channel chosen by the user
%   obj is the function object
%   C1 is the column connected to Positive Current (I+) (1 to 16)
%   C2 is the column connected to Negative Current (I-) (1 to 16)

% Default Slot No. & Current Sources (I+ and I-) %
if exist('S','var') == 0
    S = 1;      % Slot No.
end          
posI = 1;       % Positive Current Row
negI = 2;       % Negative Current Row

% Dummy Protection %
if C1 < 1 || C1 > 16 || C2 < 1 || C2 > 16
    error('Error - Column number must be between 1 to 16')
end

% Execution %
closeCH(obj, posI, C1, S);
closeCH(obj, negI, C2, S);
