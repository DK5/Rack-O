load save11.mat;
TEMP(PPMS_obj,300,4,0);
setupIV(nv_obj,sm_obj);    % IV setup
I = []; V = [];    % preallocation - Keithley
T = []; H = [];    % preallocation - PPMS
wait4temp(PPMS_obj);  % Wait for Temperature
Temp = 300:-1.5104:10;
for Tind=1:length(Temp)
    % Scan Temperature from 300[°K] to 10[°K] by spacing of -1.5104[°K]. Rate 4[°K/min], Fast settle
    TEMP(PPMS_obj,Temp(k),4,0);
    [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'V',0,5,100);   % IV measurement (Voltage): center 0[V] , span  5[V] , 100 steps
    I{end+1*(s==1),s} = Idata;     % IV current
    V{end+1*(s==1),s} = Vdata;     % IV voltage
    FileName1 = 'C:\Users\B\Documents\MATLAB\Devices\Rack-O\General n Scripts\TestsNb_loops_@T=<T>';    % original File Name
    FileName = filenameReplace(FileName1,'T',Temp(Tind),'H',Fiel(Find));    % Replace file name <>
    eval(['save(','''',FileName,'.mat','''',');'])
end

