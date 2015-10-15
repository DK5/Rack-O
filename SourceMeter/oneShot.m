function [ data ] = oneShot( cs_obj , func )
%oneShot gets the value of current/voltage at the moment
%   cs_obj is the current source object
%   func is the source function: 'c' - current ; 'v' - voltage
switch lower(func)
    case 'c'
        str = 'CURR?';
    case 'v'
        str = 'VOLT?';
end

data = query(cs_obj,['measure:',str]);

end

