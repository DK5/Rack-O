function freq( obj , freq )
%freq writes frequency to the device
%   freq is the desired frequency
%   obj is the desired device
try
    fprintf(obj, ['freq ',num2str(freq)]);   % write the frequency 
catch
    disp('Error')
end

