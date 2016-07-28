%This function makes the nanovoltmeter measuring countiniously
function Vread = VcontMeas(nv_obj, Tread, Tintegration)
% continuos measure of voltage over time
%   Tread - total tome
%% Set 2182 NanoVoltmeter object configuration
fclose(nv_obj);
BufferSize=2^14;
set(nv_obj,'InputBufferSize',BufferSize);
set(nv_obj,'OutputBufferSize',BufferSize);
set(nv_obj,'Timeout',8);
fopen(nv_obj);
%%
fprintf(nv_obj,':SYSTem:PRESet'); % setup V cont meas
IntegrationTime(nv_obj,Tintegration);
%%
maxRead = 1024;
interval = maxRead*Tintegration; 
Vread = zeros(ceil(Tread/interval));
Tmax = floor(Tread/interval);
Tres = Tread/interval - Tmax ;
vlen = 1;

store_nv(nv_obj);   % start storing readings
for time = 0:1:Tmax
    pause(interval);    % wait for measuring
    reads = read_nv(nv_obj);    % get measurements
    rlen = length(reads);
    Vread(vlen:(vlen+rlen-1)) = reads;
    vlen = rlen + vlen;
%     Vread = [Vread, reads];     % store in array
end
pause(Tres);
reads = read_nv(nv_obj);    % get measurements
rlen = length(reads);
Vread(vlen:(vlen+rlen-1)) = reads;
vlen = rlen + vlen;
Vread(vlen:end) = [];
end