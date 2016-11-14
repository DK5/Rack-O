function RvsTmeasTest

close all
%%  Open File
filename = 'R_vs_T_Keithley_Test02Timer.txt';

%%  Innitialization of DATA
exec = 5;
ppms_ex = 3;	% PPMS executions
k_ex = 10;      % keithley executions
% rows = number of executions
% 6 colomns: 1-time, 2-temp, 3-field, 4-volt1, 5- volt2, 6-current
kData = NaN(k_ex,6);
pData = NaN(ppms_ex,6);

%%	Decleration of keithleys' timer
k_timer = timer;
k_timer.Name = 'Keithleys timer';
k_timer.ExecutionMode = 'fixedSpacing';
k_timer.Period = 0.001;
k_timer.StartFcn = 'kData = NaN(k_ex,4); k = 1;';	% reset PPMS data & indexing
k_timer.TimerFcn = ...  % k_timer.TimerFcn = get data from the keithleys; promote k to next row
   ['[kData(k,1),kData(k,2:4)] = kActivity(nv_obj,sm_obj,switch_obj);',...
    'k = k+1;'];
k_timer.TasksToExecute = k_ex;

%%  Decleration of PPMS timer
ppms_timer = timer;
ppms_timer.Name = 'PPMS timer';
ppms_timer.ExecutionMode = 'fixedSpacing';
ppms_timer.Period = 0.001;
ppms_timer.StartFcn = 'pData = NaN(ppms_ex,3); p = 1';	% reset PPMS data & indexing
ppms_timer.TimerFcn =  ... % ppms_timer.TimerFcn = get data from the ppms; promote p to next row
    ['[PPMS_data(p,1),PPMS_data(p,2:3)] = pActivity(PPMSobj);',...
     'p = p+1;'];
ppms_timer.TasksToExecute = ppms_ex;

%% GPIB connenction
switch_obj=GPcon(5,0);
nv_obj=GPcon(6,0);
sm_obj=GPcon(23,0);
PPMS=GPcon(15,0);

%% legs setup
currdir='D:\Dropbox\Yeshurun\omri_s\Journal\2016\Nov10\';

conf=readtable([currdir,'conf.csv']);
Ip=table2array(conf(:,1));
Im=table2array(conf(:,2));
Vp=table2array(conf(:,3));
Vm=table2array(conf(:,4));

%% Setup keithley
deltaSetup( nv_obj , sm_obj )
relative(nv_obj,'OFF')
IntegrationTime(nv_obj,1/50)
beeper(sm_obj)

%% declaration
close all
dR=[]; dV=[] ;dI=[];
T=300;
t=1;

%% Start Timing
tic

%% First Measurement
TEMP(PPMS,9.9,5,0);	% send PPMS to 9.9 K by rate of 5K/min
T = ReadPPMSdata(PPMS,1);
while T > 10    % while Temp is above 10K
    allData = MeasBlock(k_timer,ppms_timer,kData,pData,filename);
    T = allData(end,2);
end
wait4temp(PPMS)
pause(300)


%% Second measurement
TEMP(PPMS,2,0.1,0); % send PPMS to 2K by rate of 0.1K/min
while T(end)>2.1    % while Temp is above 2.1K - measure
    allData = MeasBlock(k_timer,ppms_timer,kData,pData,filename);
    T = allData(end,2);
end

%% end of measurement
Shutdown(PPMS)
SendGmailPPMS('omri_s@yahoo.com','PPMS finnished measuring R vs T' ,...
    ' Check out the results ')

%% Normalized plot
%     plot(T,[dR(:,1)/max(dR(:,1)),-dR(:,2)/max(-dR(:,2))],'.')

end

%%
function [TimeSig,dV,dI,dR] = kActivity(nv_obj,sm_obj,switch_obj)
    for CH=1:length(Im)
        openAllCH (switch_obj)
        switchCurrent (switch_obj, 'ON', Im(CH), Ip(CH));
        switchVoltage (switch_obj, 'ON', Vm(CH), Vp(CH));
        pause(0.1)
%         wait4OPC(switch_obj)
        [Idata,Vdata] = deltaExecuteSpan(nv_obj,sm_obj,'c',0,0.1,1);
        dV(CH)=Vdata(:,2);
        dI(CH)=Idata(:,2);
        dR(CH)=-dV(t,CH)./dI(t,CH);
        TimeSig = toc;
    end
end

%%
function [TimeSig , Temp , Field] = pActivity(PPMS)
    Temp = ReadPPMSdata(PPMS,1); % Meausres temperature
    disp(['T = ',num2str(Temp),' K'])
    Field = 0;
    TimeSig = toc;
end

%%
function [interpData] = MeasBlock(k_timer,ppms_timer,kData,pData,filename)
    %%  Start timers
    start(k_timer);
    start(ppms_timer);
    %% Wait for all timers executions
    wait(ppms_timer);
    %%  Stop timers
    stop(k_timer);
    stop(ppms_timer);

    %%  Generating raw data
    kData(isnan(kData(:,1)),:) = [];    % delete all NaN values where there is no time stamp
    klen = size(kData,1);               % get kData rows size

    pData(isnan(pData(:,1)),:) = [];% delete all NaN values where there is no time stamp
    ppms_len = size(pData,1);           % get kData rows size

    rawData = NaN(klen+ppms_len,6);         % generate raw data which will contain ppms & kData
    rawData(1:klen,1) = kData(:,1);         % insert time values of kData
    rawData(1:klen,4:6) = kData(:,2:end);   % insert data values of kData into proper cols
    rawData((klen+1):end,1:3) = pData;      % insert PPMS data (time&values)

    %{  
        rawData
        ----------------------------------------------------------
        1-time | 2-temp | 3-field | 4-volt1 | 5- volt2 | 6-current
        ----------------------------------------------------------
          ...  |   NaN  |   NaN   | ...         ...         ...
         kData |   NaN  |   NaN   | ...        kData        ...
          ...  |   NaN  |   NaN   | ...         ...         ...
          ...       PPMS_Data     |   NaN   |   NaN    |    NaN
          ...       PPMS_Data     |   NaN   |   NaN    |    NaN
    %}


    %%  Sorting raw data by time
    sortData = sortrows(rawData,1); % sort by time (1st col) and get sorted rows indices

    %%  Interpolating
    interpData = InterpBlock(sortData);

    %%	Write data to the end of the file
    dlmwrite(filename,interpData,'-append','delimiter','\t','newline','pc','precision',7);

    %%  Reset Workspace
    clearvars k p kData pData
end