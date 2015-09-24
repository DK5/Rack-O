function wait4read( volt_obj )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

opc = 0; % operation completed
while opc~=1
    opc = str2double(query(volt_obj,'*OPC?'));
end

