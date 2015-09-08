function inSRC( obj1 , str )
%inSRC sets the input source of the lock-in
%   str: A | A-B | I or 0|1|2 

if ischar(str)  % cancel case sensetivity
    str = lower(str);
end

switch str
    case {0,'0','A'}
        val = '0';
    case {1,'1','A-B'}
        val = '1';
    case {2,'2','I'}
        val = '2';
    otherwise
        error('Error - not a valid input');      
end

try
    fprintf(obj1, ['isrc ',val]);
catch
    disp('Error');
end