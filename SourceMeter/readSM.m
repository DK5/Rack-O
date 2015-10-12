function [ vals ] = readSM( obj1 )
%read returns array of readings from the source meter
%   read does NOT aborts the measure, it pauses it then restarting
%   obj1 = source meter object
%   vals = returned array
data = query(obj1,':read?');
vals = str2double(strsplit(data,','));	% Export readings to array
end