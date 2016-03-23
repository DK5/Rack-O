% After creating an object, use this function to change the buffer size of
% a Keithley measurement device.
% Buffer size is 18*#ofPoints (18bits)
% Default is 18*1024=18432;
function setBuffer(obj1,Buffersize)
if exist('Buffersize','var')==0
    Buffersize=18432;
end
if exist('obj1','var')==1
    fclose(obj1)
    set(obj1, 'InputBufferSize', Buffersize);
    set(obj1, 'OutputBufferSize', Buffersize);
    fopen(obj1)
else
    disp('Error: Object does not exist')
end