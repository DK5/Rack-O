function [Helium]=HeliumLevel(PPMSobj)
Helium=GetValue(query(PPMSobj, 'LEVEL?'));
while (Helium(1)<100 & Helium(1)>30)==0
    Helium=GetValue(query(PPMSobj, 'LEVEL?'));
end
Helium=Helium(1);