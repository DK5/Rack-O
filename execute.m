function execute( obj1 )
%execute simply generates the function we set (ampl,freq) from the FG
%   obj1 is the function generator object

try
    fprintf(obj1, 'execute');
catch
    disp('Error');
end

