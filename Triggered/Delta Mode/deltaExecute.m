function [reads] = deltaExecute( volt_obj , cs_obj , current, samples)
%deltaExecute( cs_obj , volt_obj , samples , current, compliance) 
% executes delta mode measuring routine
%   cs_obj = current source object
%   volt_obj = voltmeter object
%   samples = number of delta samples
%   current = current supply (in uA)
%   compliance = voltage protection level (max voltage)
%% voltmeter
fprintf(volt_obj,':TRACe:CLEar');	% Clear readings from buffer

%% current source
current = current*1e-6;
listStr = [num2str(current),',',num2str(-current)];

fprintf(cs_obj,[':TRIGger:COUNt ',num2str(samples)]);	% Specify trigger count (1 to 2500);
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