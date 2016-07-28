fprintf(nv_obj,':SYSTem:PRESet');
% setup V cont meas
V = [];
Tread = 5;   % 5 seconds
Tintegration = 0.02;   % integration time
maxRead = 1024;
interval = maxRead*Tintegration;
IntegrationTime(nv_obj,Tintegration);

Tmax = floor(Tread/interval);
Tres = Tread/interval - Tmax ;

store_nv(nv_obj);   % start storing readings
for time = 0:1:Tmax
    pause(interval);    % wait for measuring
    reads = read_nv(nv_obj);    % get measurements
    V = [V, reads];     % store in array
end
pause(Tres);
reads = read_nv(nv_obj);    % get measurements
V = [V, reads];     % store in array