load stest.mat
deltaSetup(nv_obj,sm_obj);
Temp = 7:0.1:7.5;
for k=1:length(Temp)
    TEMP(PPMS_obj,Temp(k),1,0);
    wait4temp(PPMS_obj);
    pause(60);
    Fiel = -1000:1:1000;
    for h=1:length(Fiel)
        FIELD(PPMS_obj,Fiel(h),10,1,0);
        % Scan on switcher configurations
        for s = 1:length(close_ind)
            openAllCH(switcher_obj);
            rows = close_ind{s}(:,1);
            cols = close_ind{s}(:,2);
            for ch = 1:size(rows,1)
                closeCH(switcher_obj,rows(ch),cols(ch),1);
            end
            deltaExecuteSpan(nv_obj, sm_obj,'C',0,1,1);    % Delta measurement (Current): center 0[uA] , span  1[uA] , 1 samples
        end
    end
end

