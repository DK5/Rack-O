function [ vals ] = read_nv( obj1 )
%read returns array of readings from the voltmeter
%   read does NOT stop the measure, it pauses it then restarting
%   obj1 = voltmeter object
%   vals = returned array

fprintf(obj1, ':trace:feed:control never');	% Stop storing readings
data = query(obj1, ':data:data?');          % Request all stored readings
% data=fscanf(obj1)                           % Request all stored readings
% length(data)
store_nv(obj1);                                % Clear and continue
vals = str2double(strsplit(data,','));      % Export readings to array
% vals(isnan(vals))=[];                       % Deletes all NaN

end