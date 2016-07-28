load WeekEndMeasurement.mat
Location='D:\Dropbox\Yeshurun\Ilan Hakimi\Nb_10nm\';
deltaSetup( nv_obj , sm_obj , 21,50e-6, 0)
Temp = 7:0.1:7.5;
for k=1:length(Temp)
    TEMP(PPMS_obj,Temp(k),10,0);
    wait4temp(PPMS_obj);
    pause(60);
    Fiel = -1000:1:1000;
    I=[];    V=[];    R=[];    T=[];    H=[];
    for h=1:length(Fiel)
        FIELD(PPMS_obj,H(j),10,0,);
        % Scan on switcher configurations
        for s = 1:length(close_ind)
            openAllCH(switcher_obj);
            rows = close_ind{s}(:,1);
            cols = close_ind{s}(:,2);
            for ch = 1:size(rows,1)
                closeCH(switcher_obj,rows(ch),cols(ch),1);
            end
            [dV,dI]=ExecuteIVspan(nv_obj,sm_obj,'c',0,1,1);% Delta Measurement
            I{end+1,s}=dI(2);
            V{end+1,s}=dV(2);
            R(end+1,s)=dV(2)/dI(2);
        end
        [data] = ReadPPMSdata(PPMSobj,[1,2]);  %PPMS data
        T(end+1)=data(1);
        H(end+1)=data(2);
    end
    filename=['Nb_R_vs_H_@T=',num2str(Temp(k)),'K.mat'];
    save([Location,filename],'T','H','I','V','R');  % Save file
end

