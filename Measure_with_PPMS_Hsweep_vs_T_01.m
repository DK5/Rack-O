close all
clear
[PPMS]=Connect2PPMS();

%Temp, Field,I1,R1,I2,R2,I3,R3
Bits=[1,2,4,5,6,7,8,9];
Hmax=400;
file(30000,length(Bits)+1)=0;
a=find(file(:,1)==0);
    k=min(a)
Rch=[3:2:7]+1;
HH=file(1:k,2+1);
RR=file(1:k,Rch);
    figure;
    h=plot(HH,RR,'.','XDataSource','HH','YDataSource','RR');
    I=7;
%     TT=fliplr([6:0.4:6.8,6.9:0.1:7.1,7.14:0.02:7.3]);
%     TT=fliplr([6.1:0.2:6.7,6.85:0.1:7.05,7.11:0.02:7.27]);
%     TT=fliplr([6.9:0.02:7.3]);
TT=fliplr([6:0.2:6.8,6.9:0.01:7.2]);
    TEMP(PPMS,TT(1),5,0)
    wait4temp(PPMS)
    FIELD(PPMS,-Hmax,10,1,1) % Warm up the magnet
    tic
for T=TT
    
    TEMP(PPMS,T,0.5,0)
    wait4temp(PPMS)
    wait4field(PPMS)
    CURRENT(PPMS,[1 2 3],[I I I])
         pause(5*60)

    for H=-Hmax:1:Hmax
        [values]=ReadPPMSdata(PPMS,Bits);
        time=toc;
        if length(values)==length(Bits)
            file(k,:)=[time values'];

            HH=file(1:k,2+1);
            RR=file(1:k,Rch);
            if mod(k,10)==1
                HeLVL=num2str(HeliumLevel(PPMS));
            end
            refreshdata(h,'caller')
            title(['T = ',num2str(values(1)),'K   H = ',num2str(H),' Oe  I = ',num2str(I),' uA     Helium Level ',HeLVL,' %'])
            drawnow
            FIELD(PPMS,H,10,1,1)
        k=k+1;
        end
    end
    CURRENT(PPMS,[1 2 3],[0 0 0])
    FIELD(PPMS,-Hmax,100,2,1)
    save('R(H,diff_T,I=7uA)_Nb_BolaX261','file')
    
    % Low Helium Level, reset field and stop measurement
    if str2double(HeLVL)<52 
        FIELD(PPMS,0,100,2,0); % Field->0     
        break
    end
    percent=find(T==TT)/length(TT);
    disp([num2str(round(percent*100)),'%    Time left: ',sec2time(toc/percent-toc)])
end

FIELD(PPMS,0,100,2,0); % Field->0 
wait4field(PPMS)

dlmwrite('R(H,diff_T,I=7uA)_Nb_BolaX261.txt',file)
% fclose(PPMS);
