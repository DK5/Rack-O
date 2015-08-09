function [ freq ] = askfreq( obj )
%freq returns the frequency of the function generator
%   obj is the desired device
try
    data1 = query(obj, 'freq?');   % read the frequency
    % the format is 'FREQUENCY 400'
    freq = str2double(data1(11:end));
catch
    disp('Error')
end
