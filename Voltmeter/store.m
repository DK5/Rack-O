function [ ] = store( obj1 )
%store simply commands the voltmeter to start storing measurements in the
%buffer
%   obj1 is the voltmeter object

fprintf(obj1, ':trac:cle');             % Clear buffer
fprintf(obj1, ':trac:poin 1024');       % 
fprintf(obj1, ':trac:feed sens');       % Store raw input readings
fprintf(obj1, ':trac:feed:cont next');  % Start storing readings

end

