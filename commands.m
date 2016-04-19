load(commands)
for s = 1:length(close_ind)
rows = close_ind{s}(:,1);
cols = close_ind{s}(:,2);
for ch = 1:size(rows,1)
closeCH(switcher_obj,rows(ch),cols(ch),1);
end
% jfjgdfgd
end
