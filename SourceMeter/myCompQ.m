function [ inComp ] = myCompQ( cs_obj , func )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
switch lower(func)
    case 'c'
         fstr = 'v';
    case 'v'
         fstr = 'c';
end

data = oneShot(cs_obj,fstr);
targetVal = target(cs_obj,fstr);
    
if data < 0.95*targetVal
        inComp = 1;
    else
        inComp =0;
end
