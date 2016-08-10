load test98.mat;
IntegrationTime(nv_obj,500);    % Set Integration Time to 500mS
compliance(nv_obj,10);    % Set Compliance to 10V
current(cs_obj,ON,5);    % Set Current to 5[uA] - ON
TEMP(PPMS_obj,4,4,0);
[Status, StatusTXT] = ReadPPMSstatus(PPMSobj);    % Read status
while Status(1)~=1 && Status(1)~=4    % while Temperature not stable
    Vread = VcontMeas(nv_obj, Tread, Tintegration);    % Measure Voltage continously
    [Status, StatusTXT] = ReadPPMSstatus(PPMSobj);    % Read status
end
FileName1 = 'C:\Users\B\Documents\MATLAB\Devices\Rack-O\General n Scripts\TestsPhaseTransition';    % original File Name
FileName = filenameReplace(FileName1,'T',Temp(Tind),'H',Fiel(Find));    % Replace file name <>
eval(['save(','''',FileName,'.mat','''',');'])
% start scan
setupIV(nv_obj,sm_obj);    % IV setup
I = []; V = [];    % preallocation - Keithley
T = []; H = [];    % preallocation - PPMS
Temp = linspace(4,20,30);
for Tind=1:length(Temp)
    % Scan Temperature from 4[°K] to 20[°K] by steps of 30. Rate 4[°K/min], Fast Settle
    TEMP(PPMS_obj,Temp(Tind),4,0);
    FIELD(PPMS_obj,-500,10,0,0);
    wait4temp(PPMS_obj);  % Wait for Temperature
    Fiel = -500:15:500;
    for Find=1:length(Fiel)
        % Scan Field from -500[Oe] to 500[Oe] by spacing of 15.1515[Oe]. Rate 10[Oe/sec], Linear, Persistent
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
            [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'V',0,5,30);   % IV measurement (Voltage): center 0[V] , span  5[V] , 30 steps
            I{end+1*(s==1),s} = Idata;     % IV current
            V{end+1*(s==1),s} = Vdata;     % IV voltage
            [data] = ReadPPMSdata(PPMSobj,[1,2]);    % PPMS data
            T(end+1)=data(1);
            H(end+1)=data(2);
            FileName1 = 'C:\Users\B\Documents\MATLAB\Devices\Rack-O\General n Scripts\TestsNb_loops_@T=<T>_@H=<H>';    % original File Name
            FileName = filenameReplace(FileName1,'T',Temp(Tind),'H',Fiel(Find));    % Replace file name <>
            eval(['save(','''',FileName,'.mat','''',');'])
        end
    end
end

