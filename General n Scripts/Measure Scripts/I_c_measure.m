%close all;
%clear;

switch_obj  =GPcon(5,0);    % Connects to the 3706A-S Switch
nV_obj      =GPcon(6,0);    % Connects to the 2182A nano-Voltmeter
src_obj     =GPcon(23,0);   % Connects to the 2401  Sourcemeter
PPMS    =GPcon(15,0);   % Connects to the PPMS

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


%%%%%%%%%% INIT NANOVOLTMETER   %%%%%%%%%%%%%%%%%
fprintf(nV_obj,':*RST');                    % Reset nanoVoltmeter
fprintf(nV_obj,':SYST:PRES');               % Return to SYSTem:PRESet defaults
fprintf(nV_obj,':SYST:FAZ OFF');            % disable Front Autozero.
fprintf(nV_obj,':TRIG:DEL 0.5');            % Set trigger delay
fprintf(nV_obj,':SAMP:COUN 10');            % Specify sample count
fprintf(nV_obj,':TRAC:FEED SENS');          % Select source of readings for buffer 
fprintf(nV_obj,':SENS:FUNC "VOLT:DC"');     % Select function: ‘VOLTage[:DC]’
fprintf(nV_obj,':SENS:VOLT:APER 10E-03');   % Determine the measurement Integration Time
fprintf(nV_obj,':INIT:CONT ON');            % Enable continuous initiation
fprintf(nV_obj,':READ?');

%%%%%%%% simple measurement %%%%%%%%%%%%
fprintf(nV_obj,':conf:volt');   % Perform CONFigure operations.
fprintf(nV_obj,':trig:del 0.5');   % Set delay for 0.5sec.
fprintf(nV_obj,':samp:coun 10');   % Set sample count to 10.
fprintf(nV_obj,':read?');   % Trigger and request readings.

fprintf(src_obj,':*RST');     % Reset current src
openAllCH (switch_obj);

switchVoltage(switch_obj,'ON', 12, 13);   %set legs for nanoVoltmeter
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


Ii=0.1;
If=10.1;
I=Ii:0.1:If;
k=1;
R_msr=zeros(length(I),1);
I_src=zeros(length(I),1);
V_msr=zeros(length(I),1);
%current(src_obj,'ON', Ii);

for i=I
    current(src_obj,'ON', i);
    fprintf(nV_obj,'read?');
    pause(20);
    data=fscanf(nV_obj);                         % Request all stored readings
    vals = str2double(strsplit(data,'VDC,'));      % Export readings to array
    vals(isnan(vals))=[];                       % Deletes all NaN
    V_msr(k)=mean(vals);
    I_src(k) = i;
    R_msr(k) = V_msr(k)/(I_src(k)*(10^-6));
    plot(I_src(1:k),R_msr(1:k));
    k=k+1;
end
voltage(src_obj,'OFF', 0);       % set voltage in current src
%current(src_obj,'OFF', 0);       % set current in current src

    
