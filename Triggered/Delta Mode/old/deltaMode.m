function [ sample ] = deltaMode( cs_obj , volt_obj )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% set 2182 voltmeter for delta mode
fprintf(volt_obj,':TRACe:CLEar');                % Clear readings from buffer
fprintf(volt_obj,':SENSe:VOLTage:DELTa ON');     % Enable or disable Delta
fprintf(volt_obj,':SENSe:VOLTage:NPLCycles 1');% Set integration rate in line cycles to minimun (0.01 to 50);
                                                % integration rate = nplc/frequency
fprintf(volt_obj,':TRIGger:DELay 0');            % Set trigger delay
fprintf(volt_obj,':TRIGger:SOURce EXTernal');    % Select control source; IMMediate, TIMer, MANual, BUS, or EXTernal.
%fprintf(volt_obj,':SYSTem:FAZero:OFF');         % Disable Front Autozero (double speed of Delta)

fprintf(volt_obj,':TRACe:POINts 100');             % Specify size of buffer; 2 (because delta takes at least 2 values) to 1024
fprintf(volt_obj, ':trac:feed sens');           % Store raw input readings
fprintf(volt_obj, ':trac:feed:cont next');      % Start storing readings

%% setup the 2400 to perform current reversal of +20uA & -20uA
fprintf(cs_obj,':SYSTem:AZERo:STATe OFF');     % Disable auto-zero
fprintf(cs_obj,':TRIGger:SOURce IMMediate');   % Specify control source as immediate
fprintf(cs_obj,':TRIGger:OUTPut SOURce');      % Output trigger after SOURce
fprintf(cs_obj,':TRIGger:DELay 0.02');         % Specify Trigger Delay
fprintf(cs_obj,':TRIGger:COUNt 4');            % Specify trigger count (1 to 2500);

fprintf(cs_obj,':SENSe:FUNCtion:CONCurrent OFF');% Disable ability to measure more than one function simultaneously
fprintf(cs_obj,':SENSe:FUNCtion "current"');   % Specify functions to enable (VOLTage[:DC], CURRent[:DC], or RESistance);
fprintf(cs_obj,':SENSe:VOLTage:PROTection:LEVel 0.2');     % Specify voltage limit for I-Source 
fprintf(cs_obj,':SENSe:VOLTage:RANGe 0.2');    % Configure measurement range  

fprintf(cs_obj,':SOURce:FUNCtion CURRent');    % Select SOURce Mode
fprintf(cs_obj,':SOURce:CURRent:MODE LIST');   % Select I-Source mode (FIXed, SWEep, or LIST);

fprintf(cs_obj,':SOURce:LIST:CURRent 20E-6,-20E-6');       % Create list of I-Source values
fprintf(cs_obj,':OUTPut ON');                  % Turn source on
fprintf(cs_obj,':INITiate');                   % Initiate source-measure cycle(s);.

%%

% pause(150e-3);

opc = 0; % operation completed
while opc~=1
    opc = str2double(query(volt_obj,'*OPC?'));
end

sample = read(volt_obj);

end