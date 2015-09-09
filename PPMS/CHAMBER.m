%   Control the PPMS CHAMBER
% action is the desired action: Purging or Venting the chamber
% Insert the action wanted in txt (no numbers needed!)
% Funtion is not case-sensitive
% Example: CHAMBER(PPMS,vent)

function CHAMBER(PPMSobj,action)
try
    switch action
    	case {'Purge','purge'}
            Cmd=['CHAMBER 1'];
            fprintf(PPMSobj, Cmd);
        case {'Vent','vent'}
            [T]=ReadPPMSdata(PPMSobj,1);
            % ??? ADD temp query and check if PPMS was sent below T=210K
            if T>290 % && query (see above)
                Cmd=['CHAMBER 4'];
                fprintf(PPMSobj, Cmd);
            else
                disp('DUMB PROOF ALERT!!! Cannot vent below 210 K')
            end
    end
catch
    disp('Error')
end
