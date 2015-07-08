function [data] = askTrace( obj1 , tnum )
%setTrace returns the value of trace tnum(1-4)
%   obj1 is the Lock-in object
try
    data = query(obj1,['outr? ',num2str(tnum)]);
catch
    disp('Error')
end

