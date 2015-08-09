function wait4field(PPMSobj)
pause(2);
[Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
while and(Status(2)~=1,Status(2)~=4)
    [Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
end