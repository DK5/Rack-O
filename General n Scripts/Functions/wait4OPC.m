function wait4OPC(obj)
error=0;
opc = 0; % operation completed
while opc~=1
    try
        opc = str2double(query(obj,'*OPC?'))
        pause(0.5)
    end
    error=error+1;
    if error>25
        disp('Error!!!')
        break
    end
end