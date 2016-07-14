% function [Idata,Vdata,TimeSig] = IVsweep( nv_obj , sm_obj , mode ,minP,maxP,stepP)
function [Idata,Vdata] = IVsweep_setup_span( nv_obj , sm_obj , mode ,centerP,spanP,pointsP)
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
% MODE{1}
%% NanoVoltmeter trigger and buffer preparation 

command=cell(1);
command{end+1}=['*RST'];
command{end+1}=[':SYSTem:PRESet'];
% command{end+1}=[':SYSTem:faz off'];
command{end+1}=[':TRIGger:DELay 0'];
command{end+1}=[':TRIGger:SOURce EXTernal'];
command{end+1}=[':TRACe:CLEar'];
command{end+1}=[':TRACe:FEED:CONTrol NEver'];
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

% command{end+1}=[':SOURce:',MODE{1},':STARt ', num2str(minP)];
% command{end+1}=[':SOURce:',MODE{1},':STOP ', num2str(maxP)];
% command{end+1}=[':SOURce:',MODE{1},':STEP ', num2str(stepP)];
% command{end+1}=[':SOURce:',MODE{1},':STEP ', num2str(stepP)];

command{end+1}=[':SOURce:',MODE{1},':CENTer ', num2str(centerP)];
command{end+1}=[':SOURce:',MODE{1},':SPAN ', num2str(centerP)];
command{end+1}=[':SOURce:',MODE{1},':POINts ', num2str(centerP)];

command{end+1}=[':SOUR:SWE:RANG AUTO'];
command{end+1}=[':SOUR:SWE:SPAC LIN'];
% command{end+1}=[':SOUR:SWE:DIREction UP/DOWn'];
command{end+1}=[':TRIG:COUN ',num2str(pointsP)];
command{end+1}=[':SOUR:DEL 0.01'];
command{end+1}=[':route:terminals rear'];
command{end+1}=[':TRACe:CLEar'];
command{end+1}=[':TRACe:POINts 2500'];
command{end+1}=[':TRAC:FEED SENS'];
command{end+1}=[':TRAC:FEED:CONT NEXT'];
command{end+1}=[':OUTP ON'];
command{end+1}=[':INIT'];
command{end+1}=['*OPC'];  % Listen to OPC later on
command(1)=[];
command=command';

execute(sm_obj,command);


%% End of measurement
wait4OPC(sm_obj);
execute(sm_obj,{':OUTP OFF'});          % Turn off source

%% Read data NanoVoltMeter
execute(nv_obj,{':TRACe:FEED:CONTrol NEver'});
data = query(nv_obj, ':data:data?');
Vdata = str2double(strsplit(data,','));      % Export readings to array    
%% Read data SourceMeter
data=query(sm_obj,':TRACe:DATA?');      % Read data from buffer
data = str2double(strsplit(data,','));  % Export readings to vector
length(data)
data=reshape(data,5,[])';               % Make measured data a table/matrix
Idata=data(:,2);                            % Measured current
% TimeSig=data(:,4);                      % Time signiture from the begening of the measurement

% plot(Vdata,Idata/1e-6,'.')
% hold all
% ylabel('I [\muA]')
% xlabel('V [Volt]')




