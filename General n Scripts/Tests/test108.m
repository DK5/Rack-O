load test108.mat;
setupIV(nv_obj,sm_obj);    % IV setup
I = []; V = [];    % preallocation - Keithley
T = []; H = [];    % preallocation - PPMS
TEMP(PPMS_obj,20,4,0);
current(sm_obj,ON,5);    % Set Current to 5[uA] - ON

[Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status
while Status(1)~=1 && Status(1)~=4    % while Temperature not stable
    Vread = VcontMeas(nv_obj, Tread, Tintegration);    % Measure Voltage continously
    [Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status
end

Temp = 20:-1.5183:4;
for Tind=1:length(Temp)
    % Scan Temperature from 20[°K] to 4[°K] by spacing of -1.6[°K]. Rate 4[°K/min], Fast Settle
    TEMP(PPMS_obj,Temp(Tind),4,0);
    FIELD(PPMS_obj,-500,10,0,0);
    wait4temp(PPMS_obj);  % Wait for Temperature
    wait4field(PPMS_obj);  % Wait for Field
    
    Fiel = -500:2:500;
    for Find=1:length(Fiel)
        % Scan Field from -500[Oe] to 500[Oe] by spacing of 2[Oe]. Rate 10[Oe/sec], Linear, Persistent
        FIELD(PPMS_obj,Fiel(Find),10,0,0);
        
        % Scan on switcher configurations
        for s = 1:length(close_ind)
            openAllCH(switcher_obj);
            rows = close_ind{s}(:,1);
            cols = close_ind{s}(:,2);
            for ch = 1:size(rows,1)
                % close all channels on this configuration
                closeCH(switcher_obj,rows(ch),cols(ch),1);
            end
            [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'C',0,20,100);   % IV measurement (Current): center 0[uA] , span  20[uA] , 100 steps
            I{end+1*(s==1),s} = Idata;     % IV current
            V{end+1*(s==1),s} = Vdata;     % IV voltage
            [data] = ReadPPMSdata(PPMS_obj,[1,2]);    % PPMS data
            T(end+1)=data(1);
            H(end+1)=data(2);
        end
    end
end

