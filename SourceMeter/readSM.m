function [ vals ] = readSM( obj1 )
%read returns array of readings from the voltmeter
%   read does NOT aborts the measure, it pauses it then restarting
%   obj1 is the voltmeter object
%   vals is the returned array

fprintf(obj1, ':trace:feed:control never');   % Stop storing readings
data = query(obj1, ':trace:data?');      % Request all stored readings
fprintf(obj1, ':trace:clear');             % Clear buffer
fprintf(obj1, ':trace:feed:control next');  % Start storing reading
vals = str2double(strsplit(data,','));  % Export readings to array

end