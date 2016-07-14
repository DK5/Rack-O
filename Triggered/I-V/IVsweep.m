% function [I,V,TimeSig] = IVsweep( nv_obj , sm_obj , mode ,minP,maxP,stepP)
%% Set 2401 SourceMeter object configuration
fclose( sm_obj );
BufferSize=20000;
set(sm_obj, 'InputBufferSize', BufferSize);
set(sm_obj, 'OutputBufferSize', BufferSize);
set(sm_obj, 'Timeout', 20);
fopen (sm_obj);

%% Set 2182 NanoVoltmeter object configuration
fclose( nv_obj );
BufferSize=1024;
set(nv_obj, 'InputBufferSize', BufferSize);
set(nv_obj, 'OutputBufferSize', BufferSize);
set(nv_obj, 'Timeout', 20);
fopen ( nv_obj );

%% Current vs Voltage mode
MODE=cell(1);
switch lower(mode)
    case 'c'
        MODE{1}='CURRent';
        MODE{2}='VOLTage';
    case 'v'
        MODE{1}='VOLTage';
        MODE{2}='CURRent';
end

%% NanoVoltmeter trigger and buffer preparation 

command=cell(1);
command{end+1}=['*RST'];
command{end+1}=[':SYSTem:PRESet'];
command{end+1}=[':SYSTem:faz off'];
command{end+1}=[':TRIGger:DELay 0'];
command{end+1}=[':TRIGger:SOURce EXTernal'];
% command{end+1}=['trig:dir acc'];  %  Wait for first trigger
command{end+1}=[':TRACe:CLEar'];
% command{end+1}=[':TRACe:FEED:CONTrol NEver'];
command{end+1}=[':TRACe:POINts 1024'];
command{end+1}=[':TRAC:FEED SENS'];
command{end+1}=[':TRACe:FEED:CONTrol NEXT'];
command(1)=[];
command=command';
execute(nv_obj,command);
IntegrationTime( nv_obj , 0.02 )

%% Sourcemeter sweep preparation and launch
command=cell(1);
command{end+1}=['*RST'];
command{end+1}=[':TRAC:FEED:CONT NEVer'];
command{end+1}=[':SENS:FUNC:CONC OFF'];

command{end+1}=['TRIG:CLE'];
command{end+1}=['ARM:DIR ACC'];
command{end+1}=['ARM:SOUR IMM'];
command{end+1}=['arm:outp none'];
command{end+1}=['TRIG:DIR ACC'];
% command{end+1}=[':TRIGger:OUTPut SOURce'];
% command{end+1}=[':ARM:SOURce TLINK'];
% command{end+1}=[':ARM:SOURce IMMediate'];
%*-*-*-*-*-*-*-*-*-*-*-**************
command{end+1}=[':TRIGger:SOURce TLINk'];         % Specify control source as T-Link trigger
% command{end+1}=[':TRIGger:SOURce IMMediate'];   % Specify control source as immediate
%*-*-*-*-*-*-*-*-*-*-*-**************

command{end+1}=[':TRIGger:OUTPut SOURce'];      % Output trigger after SOURce
command{end+1}=['TRIG:INP SENS'];
% command{end+1}=['trig:dir sour'];       % Skip first trigger
command{end+1}=[':SOUR:FUNC ',MODE{1}];
% command{end+1}=[':SENS:FUNC ''',MODE{2},':DC'''];
command{end+1}=[':SENS:FUNC ''','CURRent',':DC'''];
command{end+1}=[':SENS:VOLT:PROT 21'];
command{end+1}=[':SOURce:',MODE{1},':MODE SWEep'];
command{end+1}=[':SOURce:',MODE{1},':STARt ', num2str(minP)];
command{end+1}=[':SOURce:',MODE{1},':STOP ', num2str(maxP)];
command{end+1}=[':SOURce:',MODE{1},':STEP ', num2str(stepP)];
command{end+1}=[':SOUR:',MODE{1},':MODE SWE'];
command{end+1}=[':SOUR:SWE:RANG AUTO'];
command{end+1}=[':SOUR:SWE:SPAC LIN'];
command{end+1}=[':TRIG:COUN ',num2str(length(minP:stepP:maxP))];
command{end+1}=[':SOUR:DEL 0.01'];
command{end+1}=[':route:terminals rear'];
command{end+1}=[':TRACe:CLEar'];
command{end+1}=[':TRACe:POINts 2500'];
command{end+1}=[':TRAC:FEED SENS'];
command{end+1}=[':TRAC:FEED:CONT NEXT'];
command{end+1}=[':OUTP ON'];
command{end+1}=[':INIT'];
command(1)=[];
command=command';

execute(sm_obj,command);
pause(10)
% execute(nv_obj,{'INIT'});
% execute(sm_obj,{'INIT'});


% for t=1:10
%     V=read2(nv_obj);
%     pause(0.5)
% end

%% End of measurement
wait4OPC(sm_obj)                        % Wait for measurement to finish
execute(sm_obj,{':OUTP OFF'});          % Turn off source

%% Read data
data = query(sm_obj,':TRACe:DATA?');	% Read data from buffer
vals = str2double(strsplit(data,','));  % Export readings to vector
data = reshape(vals,5,[])';	% Make measured data a table/matrix
I = data(:,2);              % Measured current
TimeSig = data(:,4);        % Time signiture from the begening of the measurement
V = read2(nv_obj);

data = query(nv_obj,':TRACe:DATA?');

reads = read1(nv_obj);

II = minP:stepP:maxP;
command = {[':OUTP OFF']};
execute(sm_obj,command);

