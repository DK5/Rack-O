function openCH (obj, R, C, S)
% openCH opens channel chosen by the user
%   obj is the function object
%   R is the row No. (1 to 6) - Current & Voltage Sources
%   C is the column No. (1 to 16) - Sample Terminals
%   S is the slot No.

% Default Slot No. %
if exist('S','var') == 0
    S = 1;
end

% Dummy Protection %
if R < 1 || R > 6
    error('Error - Row number must be between 1 to 6')
end

if C < 1 || C > 16
    error('Error - Column number must be between 1 to 16')
end

% Execution %
try 
    fprintf(obj, ['channel.open("',num2str(S),num2str(R),num2str(C,'%02d'),'")']);
catch
    error('Error opening channel');
end
