% This function resets (make the measured voltage at the moment = zero) the
% voltage reading of the nanovoltmeter.
% This can be used by shorting the nanovoltmeter to itself, waiting a bit
% for the voltage to drop and turning the 'mode' of the function ON.
% *** it is better to turn off the function first and then turn it back on.
function relative(nv_obj,mode)
switch lower(mode)
    case 'on'
        command = cell(1);
%         command{end+1}=':sens:volt:ref:ACQuire';
        command{end+1}=':sens:volt:ref:stat on';
        command(1)=[];
        execute(nv_obj,command);
    case 'off'
        execute(nv_obj,{':sens:volt:ref:stat off'})
end


