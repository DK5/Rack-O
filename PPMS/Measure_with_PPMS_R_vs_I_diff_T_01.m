close all
clear
[PPMS]=Connect2PPMS();

%Temp, Field,I1,R1,I2,R2,I3,R3
Bits=[1,2,4,5,6,7,8,9];
file(10000,length(Bits)+1)=0;
a=find(file(:,1)==0);
    k=min(a)
    
Rch=[3:2:7]+1;
II=file(1:k,Rch+1);
RR=file(1:k,Rch);
    figure;
    h=plot(II,RR,'.','XDataSource','II','YDataSource','RR');
    drawnow
    HeLVL=num2str(HeliumLevel(PPMS))
TT=[6.7]
tic
for T=TT
    TEMP(PPMS,T,0.5,1)
    wait4temp(PPMS)
    pause(1)
    stop=0;
    I=[1 1 1];
    while stop==0
        CURRENT(PPMS,[1 2 3],I);
%         pause(2)
        [values]=ReadPPMSdata(PPMS,Bits)
        time=toc;
        if length(values)==length(Bits)
            file(k,:)=[time values'];
            
            II=file(1:k,Rch+1);
            RR=file(1:k,Rch);
%             refreshdata(h,'caller')
            h=plot(II,RR,'.','XDataSource','II','YDataSource','RR');
            title(['T = ',num2str(values(1)),'K   T(target) = ',num2str(T),' K  I = ',num2str(mean(I)),' uA     Helium Level ',HeLVL,' %'])
            drawnow
            k=k+1;
                stop=prod(RR>8000);
            if mod(k,10)==1
                HeLVL=num2str(HeliumLevel(PPMS));
            end
            dI=[1 1 1];
            I=I+dI;
        end
    end
    CURRENT(PPMS,[1 2 3],[0 0 0])
end