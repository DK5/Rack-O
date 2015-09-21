%%  Connecting GPIB devices
volt1obj = GPcon(9,2);	% first voltmeter object
volt2obj = GPcon();     % seconed voltmeter object
csobj = GPcon(10,2);      % current source object
lockin = GPcon(12);     % lock-in object

%%  Innitialization of DATA
k = 1;

kData = NaN(1e1,6);     % 1-time, 2-temp, 3-field, 4-volt1, 5- volt2, 6-current
PPMS_data = NaN(1e1,6); % 1-time, 2-temp, 3-field, 4-volt1, 5- volt2, 6-current

%%	Decleration of keithleys' timer
k_timer = timer;
k_timer.Name = 'Keithleys timer';
k_timer.ExecutionMode = 'fixedRate';
k_timer.Period = 0.5;
% k_timer.UserData = cell(1,4);
k_timer.TimerFcn = ...
   ['[kData(k,4),kData(k,5),kData(k,6),kData(k,1)] = kActivity(volt1obj,volt2obj,csobj);',...
    'k=k+1;'];
% k_timer.TasksToExecute = 4;

%%  Decleration of PPMS timer
ppms_timer = timer;
ppms_timer.Name = 'PPMS timer';
ppms_timer.ExecutionMode = 'fixedRate';
ppms_timer.Period = 0.5;
ppms_timer.TimerFcn = ppmsActivity();

%%  Start timers
start(k_timer);
start(ppms_timer);

%%  Stop timers
stop(k_timer);
stop(ppms_timer);

%%  Generating raw data
kData(isnan(kData(:,1)),:) = [];    % delete all NaN values where there is no time stamp
klen = size(kData,1);             % get kData rows size

PPMS_data(isnan(PPMS_data(:,1)),:) = [];  % delete all NaN values where there is no time stamp
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

sortData = NaN(size(rawData));
dataBlock = [];

sortData(   ) = sortrows(rawData(:,1)); % sort by time (1st col) and get sorted rows indices


