function [ data ] = target( cs_obj , func )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch lower(func)
    case 'c'
        str = 'CURR?';
    case 'v'
        str = 'VOLT?';
end
    data = query(cs_obj,[':source:',str]);
end
