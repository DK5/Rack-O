function compliance( cs_obj , limit)
% compliance specifies protection level of voltage

limitStr = num2str(limit);

fprintf(cs_obj,':SENSe:VOLTage:PROTection:LEVel ',limitStr);     % Specify voltage limit for I-Source 

end