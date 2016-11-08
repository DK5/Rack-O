function wait4temp(PPMSobj)
% pause(2);
[Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
while Status(1)~=1
    [Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
end