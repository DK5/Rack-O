function ScanField(obj,Hmin,Hmax,rate)
% FIELD(PPMS,Hmin,10,1,1)
% wait4field();
for H=Hmin:Hmax
    FIELD(PPMS,H,10,1,1)
    pause(rate/60)
end