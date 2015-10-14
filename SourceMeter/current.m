function current( cs_obj , state , uamps )
%current( cs_obj , uamps ) supplies current from source meter
%   cs_obj = current source object
%   uamps = current level in uAmpere

fprintf(cs_obj,[':OUTPut ', state]);   % Turn source on/off
sourceFunc(cs_obj, 'c');
amps = uamps*10^-6;
fprintf(cs_obj, [':source:current ',num2str(amps)]);

end

