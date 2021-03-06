function [Idata,Vdata] = executeIV(nv_obj,sm_obj,mode,minP,maxP,stepP,DIRE)
% executeIV(nv_obj,sm_obj,mode,minP,maxP,stepP) executes IV measuring
% routine, by specified values
%   nv_obj - nano-Voltmeter object
%   sm_obj - SourceMeter object
%   mode   - 'C' for current scanning in uA, 'V' for voltage
%   minP,maxP,stepP - minimum point ,maximum point, step (spacing) 

%% DIREction
if exist('DIRE','var') == 0
    DIRE = 'up';
end

switch lower(DIRE)
    case {'down','d'}
        DIRE='DOWN';
    otherwise
        DIRE='UP' ;
end

%% Current vs Voltage mode
MODE = cell(1,2);
switch lower(mode)
    case 'c'
        MODE = 'CURRent';
            minP=minP*1e-6;
            maxP=maxP*1e-6;
            stepP=stepP*1e-6;
    case 'v'
        MODE = 'VOLTage';
end

%% NanoVoltMeter current & mode configuration
command = cell(1);
command{end+1}=':TRACe:CLEar';
command{end+1}=':TRACe:FEED:CONTrol NEver';
% command{end+1}=':TRAC:FEED SENS';
command{end+1}=':TRACe:FEED:CONTrol NEXT';
command(1)=[];
command=command';
execute(nv_obj,command);

%% SM current & mode configuration
command = cell(1);
command{end+1}=':TRACe:FEED:CONTrol NEver';
% command{end+1}=':TRAC:FEED SENS';
command{end+1}=':TRACe:CLEar';
command{end+1}=':TRACe:FEED:CONTrol NEXT';
command{end+1}=[':SOUR:FUNC ',MODE];
command{end+1}=[':SOURce:',MODE,':MODE SWEep'];
command{end+1}=[':SOURce:',MODE,':STARt ', num2str(minP)];
command{end+1}=[':SOURce:',MODE,':STOP ', num2str(maxP)];
command{end+1}=[':SOURce:',MODE,':STEP ', num2str(stepP)];
command{end+1}=[':TRIG:COUN ',num2str(length(minP:stepP:maxP))];
command{end+1}=':OUTP ON';
command{end+1}='*OPC';  % Listen to OPC later on
command{end+1}=':INIT';

command(1)=[];
command=command';
execute(sm_obj,command);

%% End of measurement
wait4OPC(sm_obj)
execute(sm_obj,{':OUTP OFF'});          % Turn off source

%% Read data NanoVoltMeter
% fprintf(nv_obj,':TRACe:FEED:CONTrol NEver');
% data = query(nv_obj, ':data:data?');
data=read2(nv_obj)'
Vdata = data;      % Export readings to array    

%% Read data SourceMeter
data = query(sm_obj,':TRACe:DATA?');      % Read data from buffer
data = str2double(strsplit(data,','));  % Export readings to vector
data = reshape(data,5,[])';               % Make measured data a table/matrix
Idata = data(:,2);                            % Measured current
% TimeSig=data(:,4);                      % Time signiture from the begening of the measurement