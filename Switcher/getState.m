function getState(obj, R, C, S)
%getState gets state of channel - open or closed
%   obj is the function object
%   R is the row No. (1 to 6) - Current & Voltage Sources
%   C is the column No. (3 to 14) - Model Terminals
%   S is the slot No.

% Default Slot No. %
if exist('S','var') == 0
    S = 1;
end

% Dummy Protection %
if R < 1 || R > 6
    error('Error - Row number must be between 1 to 6');
end

if C < 3 || C > 14
    error('Error - Column number must be between 3 to 14');
end

% Execution %
try 
    fprintf(obj, ['channel.getState("',num2str(S),num2str(R),num2str(C,'%02d'),'")']);
catch
    error('Error checking channel state');
end


