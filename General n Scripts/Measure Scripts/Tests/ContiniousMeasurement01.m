[Status, StatusTXT]=ReadPPMSstatus(PPMS);

while Status(1)~=1
    pause(1)
    T=ReadPPMSdata(PPMS,1);
    clc
    disp(['Temperature: ',num2str(T),' K'])
    [Status, StatusTXT]=ReadPPMSstatus(PPMS);
end