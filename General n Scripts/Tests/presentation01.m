load presentation01.mat;
setupIV(nv_obj,sm_obj);    % IV setup
compliance(nv_obj, 2);
TEMP(PPMS_obj,20,4,10,1);    % Set Temperature to 20[°K] in rate 4[°K/min]
FIELD(PPMS_obj,-100,100,1);    % Set Field to -100[Oe] in rate 100[Oe/min]
wait4field(PPMS_obj);  % Wait for Field
wait4temp(PPMS_obj);  % Wait for Temperature
Temp = 20:0.5:4;
for k=1:length(Temp)
    % Scan Temperature from 20[°K] to 4[°K] by spacing of -0.5[°K]. Rate 0.5[°K/min], Fast Settle
    TEMP(PPMS_obj,Temp(k),0.5,0);
    FIELD(PPMS_obj,-100,10,0,0);
    wait4temp(PPMS_obj);  % Wait for Temperature
    Fiel = linspace(-100,100,1000);
    for h=1:length(Fiel)
        % Scan Field from -100[Oe] to 100[Oe] by steps of 1000. Rate 10[Oe/sec], Linear, Persistent
        FIELD(PPMS_obj,Fiel(h),10,0,0);
        [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'C',0,20,41);   % IV measurement (Current): center 0[uA] , span  20[uA] , 41 steps
        I{end,s} = Idata;     % IV current
        V{end,s} = Vdata;     % IV voltage
    end
    [data] = ReadPPMSdata(PPMSobj,[1,2]);    % PPMS data
    T(end+1)=data(1);
    H(end+1)=data(2);
end

