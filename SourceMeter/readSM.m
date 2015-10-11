function [ vals ] = readSM( obj1 )
%read returns array of readings from the source meter
%   read does NOT aborts the measure, it pauses it then restarting
%   obj1 = source meter object
%   vals = returned array

fprintf(obj1, ':trace:feed:control never');	% Stop storing readings
data = query(obj1, ':trace:data?');         % Request all stored readings
fprintf(obj1, ':trace:clear');              % Clear buffer
fprintf(obj1, ':trace:feed:control next');  % Start storing reading
vals = str2double(strsplit(data,','));      % Export readings to array

end