function setupIV(nv_obj,sm_obj)

Icompliance = 1.05;
Vcompliance = 21;

% setupIV(nv_obj,sm_obj) setting-up the IV triggered measurment

%% Set 2401 SourceMeter object configuration
fclose(sm_obj);
BufferSize = 2^20;
set(sm_obj,'InputBufferSize', BufferSize);
set(sm_obj,'OutputBufferSize', BufferSize);
set(sm_obj,'Timeout', 8);
fopen(sm_obj);

%% Set 2182 NanoVoltmeter object configuration
fclose(nv_obj);
BufferSize=2^14;
set(nv_obj,'InputBufferSize',BufferSize);
set(nv_obj,'OutputBufferSize',BufferSize);
set(nv_obj,'Timeout',8);
fopen(nv_obj);

%% NanoVoltmeter trigger and buffer preparation 
command = cell(1);
command{end+1}='*RST';
command{end+1}=':SYSTem:PRESet';
command{end+1}=[':SENSe:VOLTage:DELTa OFF'];
command{end+1}=':TRIGger:DELay 0';
command{end+1}=':TRIGger:SOURce EXTernal';
command{end+1}=':TRACe:CLEar';
command{end+1}=':TRACe:FEED:CONTrol NEver';
command{end+1}=':TRACe:POINts 1024';
command{end+1}=':TRAC:FEED SENS';
command{end+1}=':TRACe:FEED:CONTrol NEXT';
command(1)=[];
command=command';
execute(nv_obj,command);
IntegrationTime(nv_obj,0.02)

%% Sourcemeter sweep preparation and launch
command=cell(1);
command{end+1}='*RST';
command{end+1}=':TRAC:FEED:CONT NEVer';
command{end+1}=':SENS:FUNC:CONC OFF';
command{end+1}='TRIG:CLE';
command{end+1}='ARM:DIR ACC';
command{end+1}='ARM:SOUR IMM';
command{end+1}='arm:outp none';
command{end+1}='TRIG:DIR ACC';
command{end+1}=':TRIGger:SOURce TLINk';         % Specify control source as T-Link trigger
command{end+1}=':TRIGger:OUTPut SOURce';      % Output trigger after SOURce
command{end+1}='TRIG:INP SENS';
command{end+1}=':SENS:FUNC ''CURRent:DC''';
command{end+1}=[':SENSe:CURRent:PROTection:LEVel ',num2str(Icompliance)];     % Specify current limit for I-Source 
command{end+1}=[':SENSe:VOLTage:PROTection:LEVel ',num2str(Vcompliance)];     % Specify voltage limit for I-Source 
command{end+1}=':SOUR:SWE:RANG AUTO';
command{end+1}=':SOUR:SWE:SPAC LIN';
command{end+1}=':SOUR:DEL 0';
command{end+1}=':route:terminals rear';
command{end+1}=':TRACe:CLEar';
command{end+1}=':TRACe:POINts 2500';
command{end+1}=':TRAC:FEED SENS';
command{end+1}=':TRAC:FEED:CONT NEXT';
command(1)=[];
command = command';
execute(sm_obj,command);