function [ data ] = target( cs_obj , func )
%target gets the target value of current/voltage
%   cs_obj is the current source object
%   func is the source function: 'c' - current ; 'v' - voltage

switch lower(func)
    case 'c'
        str = 'CURR?';
    case 'v'
        str = 'VOLT?';
end

try
    data = query(cs_obj,[':source:',str]);
catch
    error('Error getting target value.')
end
