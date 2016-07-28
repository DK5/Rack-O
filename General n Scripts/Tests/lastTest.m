load lastTest.mat;
setupIV(nv_obj,sm_obj);
% Scan on switcher configurations
for s = 1:length(close_ind)
    openAllCH(switcher_obj);
    rows = close_ind{s}(:,1);
    cols = close_ind{s}(:,2);
    for ch = 1:size(rows,1)
        closeCH(switcher_obj,rows(ch),cols(ch),1);
    end
    [Idata,Vdata] = executeIVspan(nv_obj, sm_obj,'C',0,1,50);   % IV measurement (Current): center 0[uA] , span  1[uA] , 50 steps
    I{end,s} = Idata;     % IV current
    V{end,s} = Vdata;     % IV voltage
end
[data] = ReadPPMSdata(PPMSobj,[1,2]);  %PPMS data
T(end+1)=data(1);
H(end+1)=data(2);

