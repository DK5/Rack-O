function ShowTempWhileWait(PPMS_obj)
[Status, StatusTXT]=ReadPPMSstatus(PPMS_obj);

while Status(1)~=1
    pause(1)
    T=ReadPPMSdata(PPMS_obj,1);
    clc
    disp(['Temperature: ',num2str(T),' K'])
    [Status, StatusTXT]=ReadPPMSstatus(PPMS_obj);
end