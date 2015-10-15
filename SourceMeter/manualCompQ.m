function [ inComp ] = manualCompQ( cs_obj , func )
%manualCompQ checks manually if in Compliance or not
%   cs_obj is the current source object
%   func is the source function: 'c' - current ; 'v' - voltage
switch lower(func)
    case 'c'
         fstr = 'v';
    case 'v'
         fstr = 'c';
end

data = oneShot(cs_obj, fstr);
targetVal = target(cs_obj, fstr);
    
if data < 0.95*targetVal
        inComp = 1;
    else
        inComp =0;
end
