%%  Connecting GPIB devices
volt1obj = GPcon(9,2);	% first voltmeter object
volt2obj = GPcon();     % seconed voltmeter object
csobj = GPcon(10,2);	% current source object
swicher = GPcon(12);    % switcher object
lockin = GPcon(12);     % lock-in object

%%  Innitialization of DATA
exec = 100;
ppms_ex = 5;	% PPMS executions
k_ex = 30;      % keithley executions
% rows = number of executions
% 6 colomns: 1-time, 2-temp, 3-field, 4-volt1, 5- volt2, 6-current
kData = NaN(k_ex,6);
PPMS_data = NaN(ppms_ex,6);

%%	Decleration of keithleys' timer
k_timer = timer;
k_timer.Name = 'Keithleys timer';
k_timer.ExecutionMode = 'fixedSpacing';
k_timer.Period = 0;
k_timer.StartFcn = 'kData = NaN(k_ex,6); k = 1;';	% reset PPMS data & indexing
k_timer.TimerFcn = ...  % k_timer.TimerFcn = get data from the keithleys; promote k to next row
   ['[kData(k,4),kData(k,5),kData(k,6),kData(k,1)] = kActivity(volt1obj,volt2obj,csobj);',...
    'k = k+1;'];
k_timer.TasksToExecute = k_ex;

%%  Decleration of PPMS timer
ppms_timer = timer;
ppms_timer.Name = 'PPMS timer';
ppms_timer.ExecutionMode = 'fixedSpacing';
ppms_timer.Period = 0;
ppms_timer.StartFcn = 'PPMS_data = NaN(ppms_ex,6); p = 1';	% reset PPMS data & indexing
ppms_timer.TimerFcn =  ... % ppms_timer.TimerFcn = get data from the ppms; promote p to next row
    ['[PPMS_data(p,4),PPMS_data(p,5),PPMS_data(p,6),PPMS_data(p,1)]'...
     ' = pActivity(volt1obj,volt2obj,csobj);',...
     'p = p+1;'];
ppms_timer.TasksToExecute = ppms_ex;

%%  Operation
for iter = 1:exec
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

PPMS_data(isnan(PPMS_data(:,1)),:) = [];% delete all NaN values where there is no time stamp
ppms_len = size(PPMS_data,1);           % get kData rows size

rawData = NaN(klen+ppms_len,6);         % generate raw data which will contain ppms & kData
rawData(1:klen,1) = kData(:,1);         % insert time values of kData
rawData(1:klen,4:6) = kData(:,2:end);   % insert data values of kData into proper cols
rawData((klen+1):end,:) = PPMS_data;    % insert PPMS data (time&values)

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
sortData = sortrows(rawData(:,1)); % sort by time (1st col) and get sorted rows indices
%%	Write sorted data to the end of the file

end

%% Delete Timers
delete(timerfind) % delete all timers