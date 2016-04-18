function current( cs_obj , state , uamps )
%current( cs_obj , uamps ) supplies current from source meter
%   cs_obj = current source object
%   uamps = current level in uAmpere

sourceFunc(cs_obj, 'c');% Select source Mode
amps = uamps*10^-6;     % convert from micro-Amps
fprintf(cs_obj, [':source:current ',num2str(amps)]);
fprintf(cs_obj,[':OUTPut ', state]);	% Turn source on/off
if strcmpi(state,'on')
	fprintf(cs_obj,':INITiate');        % Initiate source-measure cycle(s)
end
end

