function [values]=GetValue(input)
try
indx=find(input==',');
N=length(indx)+1;
values=zeros(N,1);
values(1)=str2double(input(1:indx(1)-1));
for i=2:N-1
    values(i)=str2double(input(indx(i-1)+1:indx(i)-1));
end
values(N)=str2double(input(indx(end)+1:end-1));
catch
    values=str2double(input(1:end-1));
end
