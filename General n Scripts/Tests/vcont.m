load vcont.mat;
TEMP(PPMS_obj,100,4,10,1);    % Set Temperature to 100[°K] in rate 4[°K/min]
[Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status
while Status(1)~=1 && Status(1)~=4    % while Temperature not stable
    Vcont = VcontMeas(nv_obj,2,1);    % Measure Voltage continously over 2[sec] , integration time: 1[]sec
    [Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status
end

