function [ vals ] = read( obj1 )
%read returns array of readings from the voltmeter
%   read does NOT stop the measure, it pauses it the restarting
%   obj1 is the voltmeter object
%   vals is the returned array

fprintf(obj1, ':trac:feed:cont nev');   % Stop storing readings
data = query(obj1, ':trac:data?');      % Request all stored readings
vals = str2double(strsplit(data,','));  % Export readings to array
store(obj1);                            % Clear and continue

end