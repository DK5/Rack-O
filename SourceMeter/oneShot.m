function [ data ] = oneShot( cs_obj , func )
%oneShot gets the value of current/voltage at the moment
%   cs_obj is the current source object
%   func is the source function: 'c' - current ; 'v' - voltage

switch lower(func)
    case 'c'
        str = 'CURR';
    case 'v'
        str = 'VOLT';
    case 'r'
        str = 'resistance';
        fprintf(cs_obj,':sense:resistance:mode manual');
end

fprintf(cs_obj,[':form:elem ',str]);    % return only resistance
data = str2double(query(cs_obj,['measure:',str,'?']));

end