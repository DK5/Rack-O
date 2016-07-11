function [reads] = deltaExecuteList(volt_obj , cs_obj , currentList)
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
listStr = num2str(currentList');
listStr = strrep(listStr,repmat(' ',1,7),',');
listStr = strrep(listStr,repmat(' ',1,6),',');
fprintf(cs_obj,[':TRIGger:COUNt ',num2str(currentList)]);	% Specify trigger count (1 to 2500);
fprintf(cs_obj,[':SOURce:LIST:CURRent ',listStr]);	% Create list of I-Source values
fprintf(cs_obj,':OUTPut ON');	% Turn source on
fprintf(cs_obj,':INITiate');	% Initiate source-measure cycle(s);.

%% readings
opc = 0; % operation completed
while opc~=1
    opc = str2double(query(volt_obj,'*OPC?'));
end

reads = read(volt_obj);
end