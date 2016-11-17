GPdis
clear
%%  Open File
filename = 'R_vs_T_Keithley_Test02Timer.txt';

%% GPIB connenction
switch_obj=GPcon(5,0);
nv_obj=GPcon(6,0);
sm_obj=GPcon(23,0);
PPMS=GPcon(15,0);

setappdata(0,'switch_obj',switch_obj);
setappdata(0,'nv_obj',nv_obj);
setappdata(0,'sm_obj',sm_obj);
setappdata(0,'PPMS',PPMS);

%%  Innitialization of DATA
exec = 5;
ppms_ex = 1;	% PPMS executions
k_ex = 10;      % keithley executions
% rows = number of executions
% 6 colomns: 1-time, 2-temp, 3-field, 4-volt1, 5- volt2, 6-current


%%	Decleration of keithleys' timer
k_timer = timer;
k_timer.Name = 'Keithleys timer';
k_timer.ExecutionMode = 'fixedSpacing';
k_timer.Period = 0.001;
k_timer.StartFcn = 'kData = [];';	% reset PPMS data & indexing
k_timer.TimerFcn = ...  % k_timer.TimerFcn = get data from the keithleys; promote k to next row
   'kData = [kData; kActivity];';
k_timer.TasksToExecute = k_ex;

%%  Decleration of PPMS timer
ppms_timer = timer;
ppms_timer.Name = 'PPMS timer';
ppms_timer.ExecutionMode = 'fixedSpacing';
ppms_timer.Period = 0.001;
ppms_timer.StartFcn = 'pData = [];';	% reset PPMS data & indexing
ppms_timer.TimerFcn =  ... % ppms_timer.TimerFcn = get data from the ppms; promote p to next row
    'pData = [pData; pActivity];';
ppms_timer.TasksToExecute = ppms_ex;


%% legs setup
currdir='D:\Dropbox\Yeshurun\omri_s\Journal\2016\Nov10\';

conf=readtable([currdir,'conf.csv']);
legs = table2array(conf);
setappdata(0,'legs',legs);

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
TEMP(PPMS,211,5,0);	% send PPMS to 9.9 K by rate of 5K/min
T = ReadPPMSdata(PPMS,1);
while T < 210    % while Temp is above 10K
    %%  Start timers
    start(k_timer);
    start(ppms_timer);
    %% Wait for all timers executions
    wait(ppms_timer);
    %%  Stop timers
    stop(k_timer);
    stop(ppms_timer);
    allData = MeasBlock(kData,pData,filename);
    T = allData(end,2);
end
wait4temp(PPMS)
% pause(300)


%% Second measurement
% TEMP(PPMS,179,0.1,0); % send PPMS to 2K by rate of 0.1K/min
% while T(end)>2.1    % while Temp is above 2.1K - measure
%     %%  Start timers
%     start(k_timer);
%     start(ppms_timer);
%     %% Wait for all timers executions
%     wait(ppms_timer);
%     %%  Stop timers
%     stop(k_timer);
%     stop(ppms_timer);
%     allData = MeasBlock(kData,pData,filename);
%     T = allData(end,2);
% end
    
%% end of measurement
Shutdown(PPMS)
SendGmailPPMS('omri_s@yahoo.com','PPMS finnished measuring R vs T' ,...
    ' Check out the results ')

%% Normalized plot
%     plot(T,[dR(:,1)/max(dR(:,1)),-dR(:,2)/max(-dR(:,2))],'.')


%%
