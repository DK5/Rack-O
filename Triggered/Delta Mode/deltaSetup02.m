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
% command{end+1}=[':SYSTem:PRESet'];
command{end+1}=[':Sens:Func Volt'];
command{end+1}=[':Sens:Volt:NPLC 1'];
command{end+1}=[':SENSe:VOLTage:DELTa ON']; % Enable or disable Delta
% command{end+1}=[':SENSe:VOLTage:NPLCycles 1']; % Set integration rate in line cycles to minimun (0.01 to 50);
                                                % integration rate = nplc/frequency
command{end+1}=[':TRIGger:DELay 0'];             % Set trigger delay
command{end+1}=[':TRIGger:SOURce EXTernal'];    % Select control source; IMMediate, TIMer, MANual, BUS, or EXTernal.
command{end+1}=[':Trig:Count 2'];
command{end+1}=[':Form:Elem Read'];             % Return readings only
command{end+1}=[':Stat:Meas:Enab 32'];          % Set to SRQ on Reading Available
% command{end+1}=[':SYSTem:FAZero:OFF'];        % Disable Front Autozero (double speed of Delta)
% command{end+1}=[':TRACe:CLEar'];            % Clear readings from buffer
% command{end+1}=[':TRACe:FEED:CONTrol NEver'];
% command{end+1}=[':TRACe:POINts 1024'];          % Specify size of buffer; 2 (because delta takes at least 2 values) to 1024
% command{end+1}=[':trac:feed sens'];             % Store raw input readings
% command{end+1}=[':trac:feed:cont next'];        % Start storing readings

command(1)=[];
command=command';
execute(nv_obj,command);
% IntegrationTime( nv_obj , 0.02 )

%% setup the 2400 to perform current reversal of +20uA & -20uA

% Set 2400 for 100mA range, 2V maximum compliance
command=cell(1);
command{end+1}=['*RST'];
command{end+1}=[':route:terminals rear'];
command{end+1}=[':Sens:Func ''Volt''']; 
command{end+1}=[':Sens:Volt:NPLC 0.01'];
command{end+1}=[':Sens:Volt:Prot 2'];
command{end+1}=[':Arm:Coun 1;Sour Imm;Tcon:Dir Sour'];

%  Set ARM layer triggering
command{end+1}=':Trig:Sour TLIN';
command{end+1}=':Trig:Dir Sour';
command{end+1}=':Trig:Tcon:Dir Sour';
command{end+1}=':Trig:Outp Sour';
command{end+1}=':Trig:Coun 2';
command{end+1}=':Trig:Del 0';
command{end+1}=':Sour:Func:Mode Curr';
command{end+1}=[':Sour:Curr:Mode List'];	
command{end+1}=[':Sour:Curr:Rang 100E-3'];
command{end+1}=[':Sour:Del 0'];

command(1)=[];
command=command';
execute(sm_obj,command);

end

