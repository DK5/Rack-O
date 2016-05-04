load commands.mat
for s = 1:length(close_ind)
    rows = close_ind{s}(:,1);
    cols = close_ind{s}(:,2);
    for ch = 1:size(rows,1)
        closeCH(switcher_obj,rows(ch),cols(ch),1);
    end
    H = linspace(77,100,1.5);
    for j=1:length(H)
        FIELD(PPMSobj,H(j),10,1,1);
        current(sm_obj, 'on',30);
        FIELD(PPMSobj,100,0.5,1,1);
    end
end
