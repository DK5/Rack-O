function setup_deltaMode( cs_obj , volt_obj , samples , current, compliance)
%setup_deltaMode( cs_obj , volt_obj , samples , current) configures current
%source & voltmeter to to delta-mode measurement before measuring
%   cs_obj = current source object
%   volt_obj = voltmeter object
%   samples = number of delta samples
%   current = current level (in uA)
%   compliance = voltage protection level (max voltage)

%% set 2182 voltmeter for delta mode
fprintf(volt_obj,':TRACe:CLEar');               % Clear readings from buffer
fprintf(volt_obj,':SENSe:VOLTage:DELTa ON');    % Enable or disable Delta
fprintf(volt_obj,':SENSe:VOLTage:NPLCycles 1'); % Set integration rate in line cycles to minimun (0.01 to 50);
                                                % integration rate = nplc/frequency
fprintf(volt_obj,':TRIGger:DELay 0');           % Set trigger delay
fprintf(volt_obj,':TRIGger:SOURce EXTernal');   % Select control source; IMMediate, TIMer, MANual, BUS, or EXTernal.
fprintf(volt_obj,':SYSTem:FAZero OFF');         % Disable Front Autozero (double speed of Delta)

fprintf(volt_obj,':TRACe:POINts 1024');         % Specify size of buffer; 2 (because delta takes at least 2 values) to 1024
fprintf(volt_obj,':trace:feed sens');           % Store raw input readings
fprintf(volt_obj,':trace:feed:cont next');      % Start storing readings

%% setup the 2400 to perform current reversal of +current & -current
fprintf(cs_obj,':SYSTem:AZERo:STATe OFF');      % Disable auto-zero
fprintf(cs_obj,':TRIGger:SOURce IMMediate');	% Specify control source as immediate
fprintf(cs_obj,':TRIGger:OUTPut SOURce');       % Output trigger after SOURce
fprintf(cs_obj,':TRIGger:DELay 0.03');          % Specify Trigger Delay
fprintf(cs_obj,[':TRIGger:COUNt ',num2str(samples*2)]);  % Specify trigger count (1 to 2500);

fprintf(cs_obj,':SENSe:FUNCtion:CONCurrent OFF');   % Disable ability to measure more than one function simultaneously
fprintf(cs_obj,':SENSe:FUNCtion "current"');   % Specify functions to enable (VOLTage[:DC], CURRent[:DC], or RESistance);
fprintf(cs_obj,':SENSe:VOLTage:PROTection:LEVel 0.2');  % Specify voltage limit for I-Source 
fprintf(cs_obj,[':SENSe:VOLTage:RANGe ',num2str(compliance*2)]);    % Configure measurement range  

fprintf(cs_obj,':SOURce:FUNCtion CURRent');    % Select SOURce Mode
fprintf(cs_obj,':SOURce:CURRent:MODE LIST');   % Select I-Source mode (FIXed, SWEep, or LIST);

currStr = num2str(current);
fprintf(cs_obj,[':SOURce:LIST:CURRent ',currStr,',-',currStr]); % Create list of I-Source values

end