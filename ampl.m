function ampl( obj, ampl )
%ampl writes amplitude to the function generator
%   obj is the function generator object
%   ampl is the desired amplitude
try
    fprintf(obj, ['ampl ',num2str(ampl)]);  % set amplitude to ampl
catch
    disp('Error')
end

