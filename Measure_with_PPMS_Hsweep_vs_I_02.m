close all
clear
[PPMS]=Connect2PPMS();

%Temp, Field,I1,R1,I2,R2,I3,R3
Bits=[1,2,4,5,6,7,8,9];
Hmax=1000;
file(40000,length(Bits)+1)=0;
a=find(file(:,1)==0);
    k=min(a)
Rch=[3:2:7]+1;
HH=file(1:k,2+1);
RR=file(1:k,Rch);
    figure;
    h=plot(HH,RR,'.','XDataSource','HH','YDataSource','RR');
    T=7;
%     II=[0.01,0.05,0.1,0.5,1:8];
    II=[9:14];
    TEMP(PPMS,T,5,0)
    wait4temp(PPMS)
    FIELD(PPMS,-Hmax,10,1,1) % Warm up the magnet
    tic
for I=II
    
    TEMP(PPMS,T,0.5,0)
    wait4temp(PPMS)
    wait4field(PPMS)
    CURRENT(PPMS,[1 2 3],[I I I])
         pause(1*60)

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
    save('R(H,diff_I,T=7K)_Nb_BolaX261','file')
    
    % Low Helium Level, reset field and stop measurement
    if str2double(HeLVL)<52 
        FIELD(PPMS,0,100,2,0); % Field->0     
        break
    end
    percent=find(I==II)/length(II);
    disp([num2str(round(percent*100)),'%    Time left: ',sec2time(toc/percent-toc)])
end

FIELD(PPMS,0,100,2,0); % Field->0 
wait4field(PPMS)

dlmwrite('R(H,diff_I,T=7K)_Nb_BolaX261.txt',file)
% fclose(PPMS);
