function [pass] = execute_deltaMode( cs_obj )
% execute_deltaMode( cs_obj ) executes delta mode measurement

fprintf(cs_obj,':OUTPut ON');   % Turn source on
fprintf(cs_obj,':INITiate');	% Initiate source-measure cycle(s);.

pass = ~query(cs_obj,':calculate2:limit:fail?');

end

