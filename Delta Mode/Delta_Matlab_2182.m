function out = g2400

% Keithley Instruments Inc. 
% Model 2182 & 2400 Delta Mode for ultra low Resistance measurements.
% This program is generated using Intrument Creation Tool from
% Instrument Control Toolbox v2.2 Matlab 6.5 (R13)

%%%%%%%%%%%%%%%% NOTE %%%%%%%%%%%%%%%%%%
% Set 2400 GPIB add = 24 & 2182 GPIB add = 25
% Connect Trigger Link cable between 2400 & 2182
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create the instrument object for 2400.
obj1 = gpib('CEC', 0, 24);

% Set the 2400 property values.
set(obj1, 'BoardIndex', 0);
set(obj1, 'ByteOrder', 'littleEndian');
set(obj1, 'BytesAvailableFcn', '');
set(obj1, 'BytesAvailableFcnCount', 48);
set(obj1, 'BytesAvailableFcnMode', 'eosCharCode');
set(obj1, 'CompareBits', 8);
set(obj1, 'EOIMode', 'on');
set(obj1, 'EOSCharCode', 'LF');
set(obj1, 'EOSMode', 'read&write');
set(obj1, 'ErrorFcn', '');
set(obj1, 'InputBufferSize', 2000);
set(obj1, 'Name', 'GPIB0-24');
set(obj1, 'OutputBufferSize', 2000);
set(obj1, 'OutputEmptyFcn', '');
set(obj1, 'PrimaryAddress', 24);
set(obj1, 'RecordDetail', 'compact');
set(obj1, 'RecordMode', 'overwrite');
set(obj1, 'RecordName', 'record.txt');
set(obj1, 'SecondaryAddress', 0);
set(obj1, 'Tag', '');
set(obj1, 'Timeout', 10);
set(obj1, 'TimerFcn', '');
set(obj1, 'TimerPeriod', 1);
set(obj1, 'UserData', []);

if nargout > 0 
    out = [obj1]; 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the instrument object for 2182.
obj2 = gpib('CEC', 0, 25);

% Set the 2182 property values.
set(obj2, 'BoardIndex', 0);
set(obj2, 'ByteOrder', 'littleEndian');
set(obj2, 'BytesAvailableFcn', '');
set(obj2, 'BytesAvailableFcnCount', 48);
set(obj2, 'BytesAvailableFcnMode', 'eosCharCode');
set(obj2, 'CompareBits', 8);
set(obj2, 'EOIMode', 'on');
set(obj2, 'EOSCharCode', 'LF');
set(obj2, 'EOSMode', 'read&write');
set(obj2, 'ErrorFcn', '');
set(obj2, 'InputBufferSize', 2000);
set(obj2, 'Name', 'GPIB0-24');
set(obj2, 'OutputBufferSize', 2000);
set(obj2, 'OutputEmptyFcn', '');
set(obj2, 'PrimaryAddress', 25);
set(obj2, 'RecordDetail', 'compact');
set(obj2, 'RecordMode', 'overwrite');
set(obj2, 'RecordName', 'record.txt');
set(obj2, 'SecondaryAddress', 0);
set(obj2, 'Tag', '');
set(obj2, 'Timeout', 10);
set(obj2, 'TimerFcn', '');
set(obj2, 'TimerPeriod', 1);
set(obj2, 'UserData', []);

if nargout > 0 
    out = [obj2]; 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set up 2182 for Delta Mode
 	fopen(obj2)
	fprintf(obj2,':*RST')                       % Reset
    fprintf(obj2,':SYSTem:PRESet')              % Return to SYSTem:PRESet defaults    
	fprintf(obj2,':TRACe:CLEar')                % Clear readings from buffer
    fprintf(obj2,':SENSe:VOLTage:DELTa ON')     % Enable or disable Delta
    fprintf(obj2,':SENSe:VOLTage:NPLCycles 0.01')  % Set integration rate in line cycles to minimun
    fprintf(obj2,':TRIGger:DELay 0')            % Set trigger delay
    fprintf(obj2,':TRIGger:SOURce EXTernal')    % Select control source; IMMediate, TIMer, MANual, BUS, or EXTernal.
    fprintf(obj2,':TRACe:POINts 1024')          % Specify size of buffer; 2 (because delta takes at least 2 values) to 1024
    fprintf(obj2,':TRACe:FEED:CONTrol NEver')   % Select buffer control mode (NEXT or NEVer)
    fprintf(obj2,':STATus:MEASurement:ENABle 512')   % Program the enable register. 
    fprintf(obj2,':*SRE 1')                     %     
pause(3);
%% setup the 2400 to perform current reversal of +20uA & -20uA
 	fopen(obj1)
	fprintf(obj1,':*RST')                       % Reset
    fprintf(obj1,':SYSTem:AZERo:STATe OFF')     % Disable auto-zero
    fprintf(obj1,':TRIGger:SOURce IMMediate')   % Specify control source as immediate
%     fprintf(obj1,':TRIGger:DIRection SOURce')   % Enable (SOURce) or disable (ACCeptor) bypass           
    fprintf(obj1,':TRIGger:OUTPut SOURce')      % Output trigger after SOURce
    fprintf(obj1,':TRIGger:DELay 0.02')            % Specify Trigger Delay
    fprintf(obj1,':TRIGger:COUNt 20')           % Specify trigger count (1 to 2500)
    fprintf(obj1,':SOURce:FUNCtion CURRent')    % Select SOURce Mode
    fprintf(obj1,':SENSe:FUNCtion:CONCurrent OFF')          % Disable ability to measure more than one function simultaneously
    fprintf(obj1,':SENSe:FUNCtion "VOLT"')      % Specify functions to enable (VOLTage[:DC], CURRent[:DC], or RESistance)
    fprintf(obj1,':SENSe:VOLTage:PROTection:LEVel 0.2')     % Specify voltage limit for I-Source 
    fprintf(obj1,':SENSe:VOLTage:RANGe 0.2')    % Configure measurement range  
    fprintf(obj1,':SENSe:VOLTage:NPLCycles 0.01')           % Specify integration rate (in line cycles):
                                                            % 0.01 to 10.3
    fprintf(obj1,':SOURce:CURRent:MODE LIST')   % Select I-Source mode (FIXed, SWEep, or LIST).
    fprintf(obj1,':SOURce:LIST:CURRent 20E-6,-20E-6')       % Create list of I-Source values
    fprintf(obj1,':OUTPut ON')                  % Turn source on
    fprintf(obj1,':INITiate')                   % Initiate source-measure cycle(s).
    

		% Used the serail poll function to wait for SRQ from 2182
		val = [1];          
		spoll(obj2,val);    % keep control until SRQ
		fprintf(obj2,':TRAC:DATA?')
		Volts = scanstr(obj2,',','%f');
        uV = Volts * 1e6;
        i =  20e-6;
        uI=[20 20 20 20 20 20 20 20 20 20]';
        R  = Volts/i; 
        mR = R * 1e3;
        
	figure(1);
	subplot(2,1,1)
	stem3(uV,uI,mR)
    hold on
	plot3(uV,uI,mR,'r')
	hold off
	view(-39.5,62)
	xlabel('Voltage drop(uV)'),ylabel('Current magnitude(uA)'),zlabel('Resistance(m-Ohms)')
	title(' Keithley 2182 & 2400: Delta Mode w. current reversal of 20uA & -20uA');
	subplot(2,1,2)
	plot(uV,':bo','LineWidth',0.5,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','r',...
                    'MarkerSize',5)
	xlabel('Reading#'),ylabel('Voltage drop(uV)')


% reset all the registers & clean up
    fprintf(obj1,':ABORT')
    fprintf(obj1,':OUTP OFF')
    fprintf(obj1,':*RST')
    
	fprintf(obj2,':STAT:PRES')
	fprintf(obj2,':*CLS ')
	fprintf(obj2,':*SRE 0')

fclose(obj1)
delete(obj1)
clear obj1

fclose(obj2)
delete(obj2)
clear obj2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Voltmeter
%  	fopen(obj2)
	fprintf(obj2,':*RST')                       % Reset
    fprintf(obj2,':SYSTem:PRESet')              % Return to SYSTem:PRESet defaults    
	fprintf(obj2,':TRACe:CLEar')                % Clear readings from buffer
    fprintf(obj2,':SENSe:VOLTage:DELTa ON')     % Enable or disable Delta
    fprintf(obj2,':SENSe:VOLTage:NPLCycles 1')  % Set integration rate in line cycles         
    fprintf(obj2,':TRIGger:DELay 0.1')          % Set trigger delay
    fprintf(obj2,':TRIGger:SOURce EXTernal')    % Select control source; IMMediate, TIMer, MANual, BUS, or EXTernal.
    fprintf(obj2,':TRACe:POINts 1024')            % Specify size of buffer; 2 to 1024
    fprintf(obj2,':TRACe:FEED:CONTrol NEver')    % Select buffer control mode (NEXT or NEVer)
    fprintf(obj2,':STATus:MEASurement:ENABle 512')   % Program the enable register. 

%% setup the 2400 to perform current reversal of +20uA & -20uA
%  	fopen(obj1)
	fprintf(obj1,':*RST')                       % Reset
    fprintf(obj1,':SYSTem:AZERo:STATe OFF')     % Disable auto-zero
    fprintf(obj1,':TRIGger:SOURce TLINk')       % Specify control source as Trigger Link
    fprintf(obj1,':TRIGger:DIRection SOURce')   % Enable (SOURce) or disable (ACCeptor) bypass           
    fprintf(obj1,':TRIGger:OUTPut SOURce')      % Output trigger after SOURce
    fprintf(obj1,':TRIGger:DELay 0')            % Specify Trigger Delay
    fprintf(obj1,':TRIGger:COUNt 20')           % Specify trigger count (1 to 2500)
    fprintf(obj1,':SOURce:FUNCtion voltage')    % Select SOURce Mode
    fprintf(obj1,':SENSe:FUNCtion:CONCurrent OFF')          % Disable ability to measure more than one function simultaneously
    fprintf(obj1,':SENSe:FUNCtion "current"')      % Specify functions to enable (VOLTage[:DC], CURRent[:DC], or RESistance)
    fprintf(obj1,':SENSe:VOLTage:PROTection:LEVel 0.2')     % Specify voltage limit for I-Source 
    fprintf(obj1,':SENSe:current:RANGe 0.2')    % Configure measurement range  
    fprintf(obj1,':SENSe:current:NPLCycles 0.01')           % Specify integration rate (in line cycles):
                                                            % 0.01 to 10.3
    fprintf(obj1,':SOURce:CURRent:MODE LIST')   % Select I-Source mode (FIXed, SWEep, or LIST).
    fprintf(obj1,':SOURce:LIST:CURRent 20E-3,-20E-3')       % Create list of I-Source values
    fprintf(obj1,':OUTPut ON')                  % Turn source on
    fprintf(obj1,':INITiate')                   % Initiate source-measure cycle(s).
    




