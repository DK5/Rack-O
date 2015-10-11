function compliance( cs_obj , limit)
% compliance specifies protection level of voltage
%   cs_obj = Source meter object
%   limit = compliance level

fprintf(cs_obj,[':SENSe:VOLTage:PROTection:LEVel ',num2str(limit)]);     % Specify voltage limit for I-Source 

end