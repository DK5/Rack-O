function [ ampl ] = askampl( obj )
%askampl returns the amplitude of the function generator
%   obj is the desired device
try
    data1 = query(obj, 'ampl?');   % read the frequency
    % the format is 'AMPLITUDE 3.2'
    ampl = str2double(data1(11:end));
catch
    disp('Error')
end
