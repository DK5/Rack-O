function harm( obj1 , h )
%harm set the detection harmonic to h
%   obj1 is the Lock-in object
%   h is the harmonic level (1-32767), max harmonic = i*f<=102kHz
try
    fprintf(obj1, ['harm ',num2str(h)]);
catch
    disp('Error')
end