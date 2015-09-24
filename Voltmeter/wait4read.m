function wait4read( volt_obj )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

opc = 0; % operation completed
read = 0;
while read<2
    opc = str2double(query(volt_obj,'*OPC?'));
    if opc == 1
        opc = 0;
        read = read+1;
    end
end

