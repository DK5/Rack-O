load commands.mat;
s = 1;
setupIV(nv_obj,sm_obj);
Temp = linspace(300,10,50);
for k=1:length(Temp)
    % Scan Temperature from 300[?K] to 10[?K] by steps of 50. Rate 4[?K/min], Fast Settle
    TEMP(PPMS_obj,Temp(k),4,0);
    [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'V',0,5,50);   % IV measurement (Voltage): center 0[V] , span  5[V] , 50 steps
    I{end,s} = Idata;     % IV current
    V{end,s} = Vdata;     % IV voltage
end

