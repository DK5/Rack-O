load RvsT_GUI1.mat;

%%
GPdis
switcher_obj=GPcon(5,0);
nv_obj=GPcon(6,0);
sm_obj=GPcon(23,0);
PPMS_obj=GPcon(15,0);

%%
T = []; H = [];    % PPMS data preallocation
I = []; V = [];    % IV measurement data preallocation
dV = []; dI = []; dR = []; % Delta measurement data preallocation
Vcont = [];        % V continous
% % connect all GPIB
deltaSetup(nv_obj,sm_obj);    % Delta setup
dI = []; dV = []; dR = [];    % preallocation - Keithley
T = []; H = [];    % preallocation - PPMS
IntegrationTime(nv_obj,0.02); Tintegration = 0.02;    % Set Integration Time to 0.02[sec]
% First Measurement
TEMP(PPMS_obj,240,5,1);    % Set Temperature to 10[°K] in rate 5[°K/min]
[Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status
while Status(1)~=1 && Status(1)~=4    % while Temperature not stable
    % Scan on switcher configurations
    for s = 1:length(close_ind)
        openAllCH(switcher_obj);
        rows = close_ind{s}(:,1);
        cols = close_ind{s}(:,2);
        for ch = 1:size(rows,1)
            % close all channels on this configuration
            closeCH(switcher_obj,rows(ch),cols(ch),1);
        end
        [Id,Vd] = deltaExecuteSpan(nv_obj, sm_obj,'C',0,100,1);    % Delta measurement (Current): center 0[uA] , span  0.1[uA] , 1 repeats
        dI(end+1*(s==1),s) = Id(2);    % span/2 current, differential current  (dI/2)
        dV(end+1*(s==1),s) = Vd(2);    % span/2 current, differential voltage  (dV/2)
        dR(end+1*(s==1),s) = Vd(2)/Id(2);  % differential resistance
        [data] = ReadPPMSdata(PPMS_obj,[1,2]);    % PPMS data
        T(end+1)=data(1);
        disp(['T = ' num2str(T(end)) 'K']);
        H(end+1)=data(2);
    end
    plot(T,dR,'.')
    drawnow
    [Status, StatusTXT] = ReadPPMSstatus(PPMS_obj)    % Read status
end
%% Second measurement
TEMP(PPMS_obj,245,0.1,1);    % Set Temperature to 2[°K] in rate 0.1[°K/min]
[Status, StatusTXT] = ReadPPMSstatus(PPMS_obj);    % Read status
while Status(1)~=1 && Status(1)~=4    % while Temperature not stable
    % Scan on switcher configurations
    for s = 1:length(close_ind)
        openAllCH(switcher_obj);
        rows = close_ind{s}(:,1);
        cols = close_ind{s}(:,2);
        for ch = 1:size(rows,1)
            % close all channels on this configuration
            closeCH(switcher_obj,rows(ch),cols(ch),1);
        end
        [Id,Vd] = deltaExecuteSpan(nv_obj, sm_obj,'C',0,100,1);    % Delta measurement (Current): center 0[uA] , span  0.1[uA] , 1 repeats
        dI(end+1*(s==1),s) = Id(2);    % span/2 current, differential current  (dI/2)
        dV(end+1*(s==1),s) = Vd(2);    % span/2 current, differential voltage  (dV/2)
        dR(end+1*(s==1),s) = Vd(2)/Id(2);  % differential resistance
        [data] = ReadPPMSdata(PPMS_obj,[1,2]);    % PPMS data
        T(end+1)=data(1);
        disp(['T = ' num2str(T(end)) 'K']);
        H(end+1)=data(2);
    end
    [Status, StatusTXT] = ReadPPMSstatus(PPMS_obj)    % Read status
end
FileName1 = 'C:\Users\ppms\Documents\MATLAB\Rack-O\General n Scripts\Measure Scripts\Tests\RvsT\RvsT\RvsT_GUI';    % original File Name
eval(['save(','''',FileName,'.mat','''',');'])

