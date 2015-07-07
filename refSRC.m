function refSRC( obj1 , str )
%refSRC sets the reference source of the lock-in
%   str: internal | sweep | external or 0|1|2 

if ischar(str)  % cancel case sensetivity
    str = lower(str);
end

switch str
    case {0,'0','internal'}
        val = '0';
    case {1,'1','sweep'}
        val = '1';
    case {2,'2','external'}
        val = '2';
    otherwise
        error('Error - not a valid input');      
end

try
    fprintf(obj1, ['fmod ',val]);
catch
    disp('Error');
end