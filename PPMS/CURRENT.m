%   Applying Current on the sample
% CH is a vector of the channels. i.e. CH=[2,3]
% I is a vector of currents for each channel in uA. i.e. [1.5,34]

function CURRENT(PPMSobj,CH,I)
try
for k=1:length(CH) %Apply Current
    Cmd=['BRIDGE ',num2str(CH(k)),' ',num2str(I(k)),' 1000.000 0 2 95.0'];
    fprintf(PPMSobj, Cmd); 
end
catch
    disp('Error')
end