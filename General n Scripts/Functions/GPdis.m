% GPdis()
%disconnect all GPIB instruments
allvar=whos;
indx=arrayfun(@(x) strcmp(x{1},'gpib'),{allvar.class});
indx=find(indx==1);
names={allvar.name};
names=names(indx);
for i=1:length(names)
    eval(['fclose(',names{i},')']);
end

