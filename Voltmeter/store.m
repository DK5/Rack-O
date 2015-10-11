function [ ] = store( obj1 )
%store simply commands the voltmeter to start storing measurements in the
%buffer
%   obj1 = voltmeter object

fprintf(obj1, ':trace:clear');              % Clear buffer
fprintf(obj1, ':trace:points 1024');        % 
fprintf(obj1, ':trace:feed sense');         % Store raw input readings
fprintf(obj1, ':trace:feed:control next');	% Start storing readings

end

