load waitTest.mat;
pause(30);
wait4temp(PPMS_obj);  % Wait for Temperature
wait4field(PPMS_obj);  % Wait for Field
[Status, StatusTXT] = ReadPPMSstatus(PPMSobj);    % Read status
while Status(2)~=1 && Status(2)~=4    % while not stable
    [Status, StatusTXT] = ReadPPMSstatus(PPMSobj);    % Read status
end
[Status, StatusTXT] = ReadPPMSstatus(PPMSobj);    % Read status
while Status(1)~=1 && Status(1)~=4    % while not stable
    [Status, StatusTXT] = ReadPPMSstatus(PPMSobj);    % Read status
end
wait4temp(PPMS_obj);  % Wait for Temperature
pause(1);

