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


%% Send to the 2400 the positive and negative current values
listStr = [num2str(center+span),',',num2str(center-span)];
execute(sm_obj,{[':SOURce:LIST:',MODE{1},' ',listStr]});

%% voltmeter
command = cell(1);
command{end+1}='*SRE 1';
command{end+1}=':Init';
command(1)=[];
command=command';
execute(nv_obj,command);

%% Turn on 2400 output and initialize sequence
command = cell(1);

command{end+1}=':Output On';
command{end+1}=':Init';

command(1)=[];
command=command';
execute(sm_obj,command);

%% Turn OFF source
wait4OPC(sm_obj);
execute(sm_obj,{':OUTP OFF'});          % Turn off source

%% Read data NanoVoltMeter
data=query(nv_obj,':Fetch?');
vals = str2double(strsplit(data,','));      % Export readings to array
Vdata=vals;




%% Read data SourceMeter
data = query(sm_obj,':TRACe:DATA?');      % Read data from buffer
data = str2double(strsplit(data,','));  % Export readings to vector
data = reshape(data,5,[])';               % Make measured data a table/matrix
IIdata=reshape(data(:,2),2,[]);            % Measured currents (center+-span/2)
Idata(:,1)=sum(IIdata)'/2;                  % center current (average)
Idata(:,2)=diff(IIdata)'/2;                % span/2 current, differential current  (dI/2)
% TimeSig=data(:,4);                      % Time signiture from the begening of the measurement
end