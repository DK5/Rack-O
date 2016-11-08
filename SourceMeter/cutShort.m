function [ isShort,res ] = cutShort( cs_obj )
%cutShort( cs_obj ) returns 1 if wires are shorted, 0 if cutout
res = oneShot(cs_obj,'r');   
if abs(res) < 1e6
        isShort = 1;
    else
        isShort = 0;
end