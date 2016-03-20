function [ vals ] = readSM( sm_obj , func)
%read returns array of readings from the source meter
%   read does NOT aborts the measure, it pauses it then restarting
%   sm_obj = source meter object
%   vals = returned array

switch lower(func)
    case 'c'
        str = 'CURR';
    case 'v'
        str = 'VOLT';
end

fprintf(sm_obj,':TRIGger:SOURce imm');     % Specify control source as immediate
fprintf(sm_obj,':SENSe:FUNCtion:CONCurrent OFF');   % Disable ability to measure more than one function simultaneously
fprintf(sm_obj,[':SENSe:FUNCtion ','"',str,'"']);   % Specify functions to enable (VOLTage[:DC], CURRent[:DC], or RESistance);
fprintf(sm_obj,[':FORM:ELEM ',str]);    % func readings only.
data = query(sm_obj,':read?');
vals = str2double(strsplit(data,','));	% Export readings to array
end