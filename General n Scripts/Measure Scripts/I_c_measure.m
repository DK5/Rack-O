%close all;
%clear;

switch_obj  =GPcon(5,2);    % Connects to the 3706A-S Switch
nV_obj      =GPcon(6,2);    % Connects to the 2182A nano-Voltmeter
src_obj     =GPcon(23,2);   % Connects to the 2401  Sourcemeter
PPMS    =GPcon(15,2);   % Connects to the PPMS

% go to required temperature
% TEMP(PPMS_obj,15,6,0);
% wait4temp(PPMS_obj);
% pause(5*60);
% TEMP(PPMS_obj,10,1,0);
% wait4temp(PPMS_obj);
% pause(300);
% TEMP(PPMS_obj,2.5,0.5,0);
% wait4temp(PPMS_obj);
% pause(300);

fprintf(nV_obj,':*RST');     % Reset nanoVoltmeter
fprintf(src_obj,':*RST');     % Reset current src
openAllCH (switch_obj);

switchVoltage(switch_obj,'ON', 8, 9);   %set legs for nanoVoltmeter
switchCurrent(switch_obj,'ON', 14, 3);  %set legs for current src

terminal(src_obj, 'rear' ); % Use rear pannel of the Sourcemeter
voltage(src_obj, 'OFF', 0);
%current(src_obj,'OFF', 0);       % set current in current src
fprintf(nV_obj,':SYSTem:faz off');     % Ignore initial DC offset




%T=5;
%TEMP(PPMS,T,0.5,0);
store(nV_obj);
Vcontmeasure(nV_obj);

% set bias voltage
read(nV_obj);
pause(10);
Vmeasurement=read(nV_obj);
V_bias=mean(Vmeasurement);


Vi=4;
Vf=8;
V_src=Vi:0.25:Vf;      % set voltage
R_msr=zeros(length(V_src),1);
I_src=zeros(length(V_src),1);
V_msr=zeros(length(V_src),1);


k=1;
IntegrationTime(nV_obj,100e-3)

%current(src_obj,'ON', I);

for v=V_src
    voltage(src_obj, 'ON', v*(10^6));
    read(nV_obj);
    pause(10);
    Vmeasurement=read(nV_obj);
    V_msr(k)= abs(V_bias - mean(Vmeasurement));
    I_src(k) = readSM(src_obj, 'c');
    R_msr(k) = V_msr(k)/I_src(k);
    plot(I_src(1:k),R_msr(1:k));
    k=k+1;
end
voltage(src_obj,'OFF', 0);       % set voltage in current src
%current(src_obj,'OFF', 0);       % set current in current src

    
