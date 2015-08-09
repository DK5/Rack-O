function refSLP( obj1 , str )
%refSLP sets the external reference slope of the lock-in
%   str: sine | rise | fall

if ischar(str)  % cancel case sensetivity
    str = lower(str);
end

switch str
    case {0,'0','sine'}
        val = '0';
    case {1,'1','rise'}
        val = '1';
    case {2,'2','fall'}
        val = '2';
    otherwise
        error('Error - not a valid input');   
end

try
    fprintf(obj1, ['rslp ',val]);
catch
    disp('Error');
end