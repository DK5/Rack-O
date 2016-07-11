function voltage( vs_obj , state , Volts)
%voltage( vs_obj , uamps ) supplies voltage from source meter
%   vs_obj = voltage source object
%   uVolts = voltage level in uVolts

fprintf(vs_obj,[':OUTPut ', state]);   % Turn source on/off
sourceFunc(vs_obj, 'v');
% volts = uVolts*10^-6;
fprintf(vs_obj, [':source:voltage ',num2str(volts)]);

end