function measureFunc( cs_obj , func)
% sourceFunc specifies source function - Voltage or Current
%   func - 'c' = Current ; 'v' = Voltage

switch func
    case 'c'
        str = '"CURR"';
    case 'v'
        str = '"VOLT"';
end

fprintf(cs_obj,[':sense:FUNCtion ',str]);	% Select SOURce Mode

end