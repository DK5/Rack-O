function compliance( sm_obj , func , limit)
% compliance specifies protection level of voltage
%   sm_obj = Source meter object
%   func = 'v' for voltage ; 'c' for vlotage
%   limit = compliance level [V or uA]

switch lower(func)
    case 'c'
        str = 'CURR';
        limit = limit*10^-6;
    case 'v'
        str = 'VOLT';
end

fprintf(sm_obj,[':SENSe:',str,':PROTection:LEVel ',num2str(limit)]);     % Specify voltage limit for I-Source 

end