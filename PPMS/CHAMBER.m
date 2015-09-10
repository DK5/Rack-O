function FIELD(PPMSobj,ChamberCode)
%   Sets valves to evacuate or vent sample chamber as specified by the integer ChamberCode
% ChamberCode is the desired action as listed:
% 0 - Seal Immediately 
% 1 - Purge and Seal
% 2 - Vent and Seal
% 3 - Pump Continuously
% 4 - Vent Continuously
  
try
    Cmd=['CHAMBER ',num2str(ChamberCode)];
    fprintf(PPMSobj, Cmd);
catch
    disp('Error')
end
