load amir&oz.mat;
setupIV(nv_obj,sm_obj);
FIELD(PPMS_obj,-100,10,1);    % Set Field to -100[Oe] in rate 10[Oe/min]
TEMP(PPMS_obj,20,10,10,1);    % Set Temperature to 20[°K] in rate 10[°K/min]
Temp = linspace(20,4,50);
for k=1:length(Temp)
    % Scan Temperature from 20[°K] to 4[°K] by steps of 50. Rate 4[°K/min], No overshoot
    TEMP(PPMS_obj,Temp(k),4,1);
    wait4temp(PPMS_obj);
    Fiel = -100:10:100;
    for h=1:length(Fiel)
        % Scan Field from -100[Oe] to 100[Oe] by spacing of 10[Oe]. Rate 5[Oe/sec], Linear, Persistent
        FIELD(PPMS_obj,Fiel(h),5,0,0);
        wait4field(PPMS_obj);
        % Scan on switcher configurations
        for s = 1:length(close_ind)
            openAllCH(switcher_obj);
            rows = close_ind{s}(:,1);
            cols = close_ind{s}(:,2);
            for ch = 1:size(rows,1)
                closeCH(switcher_obj,rows(ch),cols(ch),1);
            end
            [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'C',0,50,100);   % IV measurement (Current): center 0[uA] , span  50[uA] , 100 steps
            I{end,s} = Idata;     % IV current
            V{end,s} = Vdata;     % IV voltage
            [data] = ReadPPMSdata(PPMSobj,[1,2]);  %PPMS data
            T(end+1)=data(1);
            H(end+1)=data(2);
        end
    end
end