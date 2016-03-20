function [ data ] = deltaSample( cs_obj , volt_obj , current , compliance , samples)
%deltaSample( csObj , voltObj , samples , models ) performs delta mode and returns specified number of
%samples for each model
%   Detailed explanation goes here
setup_deltaMode(cs_obj , volt_obj , samples, current , compliance);  % setup
execute_deltaMode(cs_obj);      % execute

pause(samples*0.035);           % wait until finished measurement
% fprintf(cs_obj,':trace:feed:control never');
data{2} = read(volt_obj)';      % read voltage data
fprintf(cs_obj,':trace:feed:control never');    % stop buffer storing
vals = query(cs_obj,':trace:data?');  % read current data
currData = str2double(strsplit(vals,',')); % Export readings to array
% reshape current data (2 cols) so mean will be trivial
ncurrData = reshape(currData, 2, numel(currData)/2);
% get mean value
data{1} = mean(abs(ncurrData))';
end