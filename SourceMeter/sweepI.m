% This function sweeps the current using the 2400 Sourcemeter.
% cs_obj is the GPIB object of the sourcemeter
% Istart,Istop,Istep  (in uA)
% Idelay  (in msec) is the delay between switching currents
% Ipoints   is the Trigger count = # sweep points.
function sweepI(cs_obj,Istart,Istop,Istep,Idelay)
N=1+(Istop-Istart)/Istep;

display(['Estimated Running Time: ' sec2time(N*Idelay)]) % Approximates and shows how much time will the measurement take

% fprintf(cs_obj,'*RST');                 % Restore GPIB default conditions.
fprintf(cs_obj,':SENS:FUNC:CONC OFF');  % Turn off concurrent functions.
fprintf(cs_obj,':SOUR:FUNC CURR');      % Current source function.
fprintf(cs_obj,':SENS:FUNC ‘VOLT:DC’'); % Volts sense function.
fprintf(cs_obj,':SENS:VOLT:PROT 1');    % 1V voltage compliance.
fprintf(cs_obj,[':SOUR:CURR:START ',upper(num2str(Istart*1e-6))]);% start current.
fprintf(cs_obj,[':SOUR:CURR:STOP ',upper(num2str(Istop*1e-6))]);  % stop current.
fprintf(cs_obj,[':SOUR:CURR:STEP ',upper(num2str(Istep*1e-6))]);  % step current.
fprintf(cs_obj,':SOUR:CURR:MODE SWE');  % Select current sweep mode.
fprintf(cs_obj,':SOUR:SWE:RANG AUTO');  % Auto source ranging.
fprintf(cs_obj,':SOUR:SWE:SPAC LIN');   % Select linear staircase sweep.
fprintf(cs_obj,[':TRIG:COUN ',upper(num2str(N))]);                % Trigger count = # sweep points.
fprintf(cs_obj,[':SOUR:DEL ',upper(num2str(Idelay*1-3))]);        % source delay.
fprintf(cs_obj,':OUTP ON');             % Turn on source output.
fprintf(cs_obj,':READ?');               % Trigger sweep, request data.

