function wait4read( volt_obj )
%wait4read( volt_obj ) pauses until voltmeter operation is complited
%   volt_obj = voltmeter object

opc = 0;    % operation not completed
while opc~=1
    opc = str2double(query(volt_obj,'*OPC?'));
end