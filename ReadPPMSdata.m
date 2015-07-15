function [data]=ReadPPMSdata(PPMSobj,Bits)
CMD=['GETDAT? ',num2str(sum(2.^Bits))];
[data]=GetValue(query(PPMSobj, CMD));
error=0;
while length(data)~=length(Bits)+2
    [data]=GetValue(query(PPMSobj, CMD));
    error=error+1;
    if error>5
        disp('Error')
        break
    end
end
    