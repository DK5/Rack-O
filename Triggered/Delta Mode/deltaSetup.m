function deltaSetup( nv_obj , sm_obj , compliance, delay)
%deltaSetup(volt_obj,cs_obj,compliance,delay) sets the nano-voltmeter and
%the source-meter to delta mode measurement
%   volt_obj - nano-voltmeter object
%   cs_obj - source-meter object
%   compliance - compliance level (Volts)
%   delay - delay between triggers (blank - 0)
if exist('delay','var') == 0
    delay = 0;
end

if exist('compliance','var') == 0
    compliance = 12;
end

%% Set 2401 SourceMeter object configuration
fclose( sm_obj )
BufferSize=2^20;
set(sm_obj, 'InputBufferSize', BufferSize);
set(sm_obj, 'OutputBufferSize', BufferSize);
set(sm_obj, 'Timeout', 8);
fopen (sm_obj)

%% Set 2182 NanoVoltmeter object configuration
fclose( nv_obj )
BufferSize=2^14;
set(nv_obj, 'InputBufferSize', BufferSize);
set(nv_obj, 'OutputBufferSize', BufferSize);
set(nv_obj, 'Timeout', 8);
fopen ( nv_obj )

%% set 2182 voltmeter for delta mode

command=cell(1);
command{end+1}=['*RST'];
command{end+1}=[':SYSTem:PRESet'];
command{end+1}=[':SENSe:VOLTage:DELTa ON']; % Enable or disable Delta
% command{end+1}=[':SENSe:VOLTage:NPLCycles 1']; % Set integration rate in line cycles to minimun (0.01 to 50);
                                                % integration rate = nplc/frequency
command{end+1}=[':TRIGger:DELay 0'];             % Set trigger delay
command{end+1}=[':TRIGger:SOURce EXTernal'];    % Select control source; IMMediate, TIMer, MANual, BUS, or EXTernal.
% command{end+1}=[':SYSTem:FAZero:OFF'];        % Disable Front Autozero (double speed of Delta)
command{end+1}=[':TRACe:CLEar'];            % Clear readings from buffer
command{end+1}=[':TRACe:FEED:CONTrol NEver'];
command{end+1}=[':TRACe:POINts 1024'];          % Specify size of buffer; 2 (because delta takes at least 2 values) to 1024
command{end+1}=[':trac:feed sens'];             % Store raw input readings
command{end+1}=[':trac:feed:cont next'];        % Start storing readings

command(1)=[];
command=command';
execute(nv_obj,command);
IntegrationTime( nv_obj , 0.02 )

%% setup the 2400 to perform current reversal of +20uA & -20uA

command=cell(1);
command{end+1}=['*RST'];
command{end+1}=[':SYSTem:AZERo:STATe OFF'];     % Disable auto-zero
command{end+1}=[':TRIGger:SOURce IMMediate'];   % Specify control source as immediate
% command{end+1}=[':TRIGger:OUTPut SOURce'];      % Output trigger after SOURce

command{end+1}='TRIG:CLE';
command{end+1}='ARM:DIR ACC';
command{end+1}='ARM:SOUR IMM';
command{end+1}='arm:outp none';
command{end+1}='TRIG:DIR ACC';
command{end+1}=':TRIGger:SOURce TLINk';         % Specify control source as T-Link trigger
command{end+1}=':TRIGger:OUTPut SOURce';      % Output trigger after SOURce
command{end+1}='TRIG:INP SENS';

command{end+1}=[':TRIGger:DELay ',num2str(delay)];	% Specify Trigger Delay
command{end+1}=[':SENSe:FUNCtion:CONCurrent OFF'];% Disable ability to measure more than one function simultaneously
command{end+1}=[':SENSe:FUNCtion ''current'''];   % Specify functions to enable (VOLTage[:DC], CURRent[:DC], or RESistance);
command{end+1}=[':SENSe:VOLTage:PROTection:LEVel ',num2str(compliance)];     % Specify voltage limit for I-Source 
% command{end+1}=[':SENSe:VOLTage:RANGe ',num2str(compliance)];    % Configure measurement range  
command{end+1}=[':SENSe:VOLTage:RANGe:AUTO ON '];
command{end+1}=':route:terminals rear';
command{end+1}=[':TRAC:FEED:CONT NEVER'];
command{end+1}=[':TRACe:CLEar'];
command{end+1}=[':TRACe:POINts 2500'];
command{end+1}=[':TRAC:FEED SENS'];
command{end+1}=[':TRAC:FEED:CONT NEXT'];

command(1)=[];
command=command';
execute(sm_obj,command);


end

