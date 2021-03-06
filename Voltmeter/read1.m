function [ vals ] = read1( obj1 )
%read returns array of readings from the voltmeter
%   read does NOT stop the measure, it pauses it then restarting
%   obj1 = voltmeter object
%   vals = returned array

data=fscanf(obj1);                         % Request all stored readings
vals = str2double(strsplit(data,','));      % Export readings to array
vals(isnan(vals))=[];                       % Deletes all NaN



