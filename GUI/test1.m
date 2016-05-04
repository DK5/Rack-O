load(test1)
Temp = 300:1:12;
for k=1:length(Temp)
TEMP(PPMSObj,Temp(j),10,1);
H = 0:1:12;
for j=1:length(H)
FIELD(PPMSobj,H(j),10,1,1);
for s = 1:length(close_ind)
rows = close_ind{s}(:,1);
cols = close_ind{s}(:,2);
for ch = 1:size(rows,1)
closeCH(switcher_obj,rows(ch),cols(ch),1);
end
current(sm_obj, 'on',0.001);
oneShot(sm_obj, 'v');
end
end
end
