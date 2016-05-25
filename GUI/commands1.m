load commands1.mat
Temp = linspace(77,100,1.5);
for k=1:length(Temp)
    TEMP(PPMSObj,Temp(k),10,1);
end
current(sm_obj, 'on',30);
TEMP(PPMSObj,100,0.5,10,1);
