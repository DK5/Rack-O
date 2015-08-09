%   Control the PPMS Magnetic Field
% H is the desired magnetic field (-90000 to 90000 Oe)
% rate is the chage rate (10-187 Oe/sec)
% approach is 0 Linear, 1 No overshoot, 2 Oscillate
% mode is 0 persistant, 1 driven

function FIELD(PPMSobj,H,rate,approach,mode)
try
    Cmd=['FIELD ',num2str(H),' ',num2str(rate),' ',num2str(approach),' ',num2str(mode)];
    fprintf(PPMSobj, Cmd);
catch
    disp('Error')
end
