load scanPPMS_test.mat
Temp = linspace(300,10,5);
for k=1:length(Temp)
    TEMP(PPMS_obj,Temp(k),4,1);
end
Fiel = linspace(0,1000,5);
for h=1:length(Fiel)
    FIELD(PPMS_obj,Fiel(h),10,2,1);
end