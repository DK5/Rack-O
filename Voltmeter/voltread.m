a = zeros(30,20);

data = cell(30,1);

fprintf(obj1, '*rst');
pause(3);
fprintf(obj1, ':Trigger:sour TIMER');
fprintf(obj1, ':TRIGger:TIMer MIN');

fprintf(obj1, ':Trigger:Count inf');
fprintf(obj1, ':Trigger:Delay 0');
fprintf(obj1, ':Sample:Count 20');
fprintf(obj1, ':trac:poin 1024');
fprintf(obj1, ':sens:volt:nplc 0.01');
%fprintf(obj1, ':trac:feed:cont next');
%fprintf(obj1, ':format sre')

for i=1:31
data{i} = query(obj1, ':read?');
%a(i,:)= cast(query(obj1, ':read?'),'uint8');
end

vals = str2double(strsplit(data{:},','));