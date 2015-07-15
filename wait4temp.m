function wait4temp(PPMSobj)
pause(2);
[Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
while and(Status(1)~=1,Status(1)~=2)
    [Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
end