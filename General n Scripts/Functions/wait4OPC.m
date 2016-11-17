function wait4OPC(obj)
error=0;
opc = 0; % operation completed
fprintf(obj,'*OPC?')
while opc~=1
    try
%         tic
        opc = str2double(query(obj,'*OPC?'))
%         opc = str2double(fscanf(obj));
%         toc
%         fprintf(obj,'*OPC')
%         pause(9)
    catch
        error=error+1;
        if error > 7
            disp('Error!!!')
            break
        end
    end
end