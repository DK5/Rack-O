fileID = fopen('test1.m');
C = textscan(fileID,'%s %s %s %s %s %s %s %s');
fclose(fileID);
celldisp(C)
clear CC
for i=1:length(C{1,1})
    line='';
    for j=1:length(C)
        line=[line,' ',C{1,j}{i,1}];
    end
    CC{i,1}=strtrim(line);
end

TABS=zeros(length(CC),1);
counter=0;
for i=1:length(CC)
    switch CC{i,1}(1:3)
        case 'for'
            counter=counter+1;
        case 'end'
            counter=counter-1;
    end  
    TABS(i)=counter;
end

for i=1:length(CC)
    switch CC{i,1}(1:3)
        case 'for'
            TABS(i)=TABS(i)-1;
    end
    tab='';
    for j=1:TABS(i)
        tab=[tab,'   '];
    end
    CC{i,1}=[tab, CC{i,1}];
end


