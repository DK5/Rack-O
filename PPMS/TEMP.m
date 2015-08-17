%   Control the PPMS Temperature
% T is the desired temperature ( 1.9 - 350 K )
% rate is the change rate ( 0 - 12 K/min)
% approach is 0 Fast Settle Approach, 1 No overshoot

function TEMP(PPMSobj,T,rate,approach)
try
    Cmd=['TEMP ',num2str(T),' ',num2str(rate),' ',num2str(approach)];
    fprintf(PPMSobj, Cmd);
catch
    disp('Error')
end
