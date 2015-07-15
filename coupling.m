function coupling( obj1 , str )
%coupling sets the input coupling of the lock-in
%   str: AC | DC or 0|1 

if ischar(str)  % cancel case sensetivity
    str = lower(str);
end

switch str
    case {0,'0','ac'}
        val = '0';
    case {1,'1','dc'}
        val = '1';
    otherwise
        error('Error - not a valid input');      
end

try
    fprintf(obj1, ['icpl ',val]);
catch
    disp('Error');
end