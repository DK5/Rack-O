function [reads] = IVvoltage( volt_obj , cs_obj , VoltageList)
%dektaExecute( cs_obj , volt_obj , samples , currentList, compliance) 
% executes delta mode measuring routine
%   cs_obj = current source object
%   volt_obj = voltmeter object
%   currentList = current list (in uA)
%   compliance = voltage protection level (max voltage)
%% voltmeter
fprintf(volt_obj,':TRACe:CLEar');	% Clear readings from buffer

%% current source
listStr = num2str(VoltageList,'%g, ');
listStr = listStr(listStr~=' ');
listStr = listStr(1:end-1);

fprintf(cs_obj,[':TRIGger:COUNt ',num2str(length(VoltageList))]);	% Specify trigger count (1 to 2500);
fprintf(cs_obj,[':SOURce:LIST:VOLTage ',listStr]);	% Create list of I-Source values
fprintf(cs_obj,':OUTPut ON');	% Turn source on
fprintf(cs_obj,':INITiate');	% Initiate source-measure cycle(s);.

%% readings
opc = 0; % operation completed
while opc~=1
    opc = str2double(query(volt_obj,'*OPC?'));
end
reads(:,1) = ReadSMbuffer( cs_obj);
reads(:,2) = reasd(volt_obj);
end