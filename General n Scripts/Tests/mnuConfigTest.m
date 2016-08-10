load mnuConfigTest.mat;
IntegrationTime(nv_obj,0.1);    % Set Integration Time to 0.1[sec]
terminal(nv_obj,'Front');    % Set Terminal to 'Front'
terminal(nv_obj,'Rear');    % Set Terminal to 'Rear'
dT = 0.1;    % Set Temperature Interval to 0.1[°K]
dH = 5 ;   % Set Field interval to 5[Oe]
compliance(sm_obj,2);    % Set Compliance to 2[V]

