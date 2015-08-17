function channel( obj1, CH )
%channel sets the function generator channel to ch
%   obj1 is the function generator object
%   CH is the desired channel number
try
    fprintf(obj1, ['channel ',num2str(CH)]);
    execute(obj1);
catch
    disp('Error')
end

