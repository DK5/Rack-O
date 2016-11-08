function wait4temp(PPMSobj,disptemp)
% pause(2);
if exist('disptemp','var') == 0
    disptemp=1;
else
    disptemp=0;
end

[Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
while Status(1)~=1
    [Status, StatusTXT]=ReadPPMSstatus(PPMSobj);
    if disptemp==1
        T=ReadPPMSdata(PPMSobj,1);
        T=ReadPPMSdata(PPMSobj,1);
        clc
        disp(['T = ',num2str(T),' K     ',StatusTXT{1}])
    end
end