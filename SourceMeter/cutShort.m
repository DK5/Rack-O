function [ isShort,res ] = cutShort( cs_obj, I )
% cutShort( cs_obj ) returns 1 if wires are shorted, 0 if cutout
% Select the current I (in uA) you want to apply.
current( cs_obj , 'on' , I );
pause(1/5)
res = abs(1e6*oneShot(cs_obj,'c'));    
% res = oneShot(cs_obj,'r');  
res=res/I;
if  res > 0.98
        isShort = 1;
    else
        isShort = 0;
end
current( cs_obj , 'off' , I );