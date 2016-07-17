function [Idata,Vdata] = deltaExecuteSpan(nv_obj,sm_obj,mode,center,span,repeats)
%deltaExecute( cs_obj , volt_obj , samples , current, compliance) 
% executes delta mode measuring routine
%   sm_obj = current source object
%   nv_obj = voltmeter object
%   mode = 'c' for current in uA , 'v' for voltage in V (from sourcemeter)
%   repeat = how many times to repeat the measurement

%% Current vs Voltage mode
MODE=cell(1);
switch lower(mode)
    case 'c'
        MODE{1}='CURRent';
        MODE{2}='VOLTage';
        center = center*1e-6;
        span = span*1e-6;
    case 'v'
        MODE{1}='VOLTage';
        MODE{2}='CURRent';
        center = center;
        span = span;
        
end

%% voltmeter
command = cell(1);
command{end+1}=':TRACe:CLEar';
command{end+1}=':TRACe:FEED:CONTrol NEver';
% command{end+1}=':TRAC:FEED SENS';
command{end+1}=':TRACe:FEED:CONTrol NEXT';
command(1)=[];
command=command';
execute(nv_obj,command);

%% current source
listStr = [num2str(center-span),',',num2str(center+span)];
command=cell(1);

command{end+1}=':TRACe:FEED:CONTrol NEver';
% command{end+1}=':TRAC:FEED SENS';
command{end+1}=':TRACe:CLEar';
command{end+1}=':TRACe:FEED:CONTrol NEXT';
command{end+1}=[':SOUR:FUNC ',MODE{1}];                    % Select SOURce Mode
command{end+1}=[':TRIGger:COUNt ',num2str(repeats)];	% Specify trigger count (1 to 2500);
command{end+1}=[':SOURce:',MODE{1},':MODE LIST'];   % Select I-Source mode (FIXed, SWEep, or LIST);
command{end+1}=[':SOURce:LIST:',MODE{1},' ',listStr];	% Create list of Source values
command{end+1}=[':OUTPut ON'];	% Turn source on
command{end+1}=[':INITiate'];	% Initiate source-measure cycle(s);.

command(1)=[];
command=command';
execute(sm_obj,command);

%% readings
wait4OPC(sm_obj);
execute(sm_obj,{':OUTP OFF'});          % Turn off source

%% Read data NanoVoltMeter
% fprintf(nv_obj,':TRACe:FEED:CONTrol NEver');
% data = query(nv_obj, ':data:data?');
% Vdata = str2double(strsplit(data,','));      % Export readings to array    
Vdata=read2(nv_obj);

%% Read data SourceMeter
data = query(sm_obj,':TRACe:DATA?');      % Read data from buffer
data = str2double(strsplit(data,','));  % Export readings to vector
data = reshape(data,5,[])';               % Make measured data a table/matrix
Idata = data(:,2);                            % Measured current
% TimeSig=data(:,4);                      % Time signiture from the begening of the measurement
end