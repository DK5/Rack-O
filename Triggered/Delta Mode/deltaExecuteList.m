function [Idata,Vdata] = deltaExecuteList(volt_obj , cs_obj , currentList)
%deltaExecute( cs_obj , volt_obj , samples , currentList, compliance) 
% executes delta mode measuring routine
%   cs_obj = current source object
%   volt_obj = voltmeter object
%   samples = number of delta samples
%   currentList = current list (in uA)
%   compliance = voltage protection level (max voltage)
%% voltmeter
fprintf(volt_obj,':TRACe:CLEar');	% Clear readings from buffer

%% current source
currentList(2,:) = -currentList(1,:);   % prepare to delta: +-
currentList = currentList(:)*1e-6;
listStr = num2str(currentList','%g, ');
listStr = listStr(listStr~=' ');
listStr = listStr(1:end-1);

fprintf(cs_obj,[':TRIGger:COUNt ',num2str(length(currentList)/2)]);	% Specify trigger count (1 to 2500);
fprintf(cs_obj,[':SOURce:LIST:CURRent ',listStr]);	% Create list of I-Source values
fprintf(cs_obj,':OUTPut ON');	% Turn source on
fprintf(cs_obj,':INITiate');	% Initiate source-measure cycle(s);.
fprintf(cs_obj,'*OPC');	% prepare to OPC

%% End of measurement
wait4OPC(sm_obj);
execute(sm_obj,{':OUTP OFF'});          % Turn off source

%% Read data NanoVoltMeter
fprintf(nv_obj,':TRACe:FEED:CONTrol NEver');
data = query(nv_obj, ':data:data?');
Vdata = str2double(strsplit(data,','));      % Export readings to array    

%% Read data SourceMeter
data = query(sm_obj,':TRACe:DATA?');      % Read data from buffer
data = str2double(strsplit(data,','));  % Export readings to vector
data = reshape(data,5,[])';               % Make measured data a table/matrix
Idata = data(:,2);                            % Measured current
% TimeSig=data(:,4);                      % Time signiture from the begening of the measurement