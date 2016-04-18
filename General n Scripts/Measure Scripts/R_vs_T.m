%clear
%[PPMS]=Connect2PPMS();

%Temp, Field,I1,R1,I2,R2,I3,R3
Bits=[1,2,4,5,6,7,8,9];
%file(30000,length(Bits)+1)=0;
%a=find(file(:,1)==0);
%   k=min(a)
%Rch=[3:2:7]+1;
%TT=file(1:k,1+1);
%RR=file(1:k,Rch);

figure;
h=plot(TT,RR,'.','XDataSource','TT','YDataSource','RR');
%     II=[0.01:0.03:0.07,0.1:0.3:0.7,1:3:10];
%II=[14:4:30,35:5:50];
T=20;
T_final=3;
while (T>T_final)
 TEMP(PPMS,T,0.5,0);
 wait4temp(PPMS);
 [values]=ReadPPMSdata(PPMS,Bits);
end

% tic
for I=II
    wait4temp(PPMS)
    CURRENT(PPMS,[1 2 3],[I I I])
         pause(10)
    stop=0;

	while stop==0
        [values]=ReadPPMSdata(PPMS,Bits);
        time=toc;
        if length(values)==length(Bits)
            file(k,:)=[time values'];
            H=file(k,2+1);
            TT=file(1:k,1+1);
            RR=file(1:k,Rch);
            if mod(k,10)==1
                HeLVL=num2str(HeliumLevel(PPMS));
            end
            refreshdata(h,'caller')
            title(['T = ',num2str(values(1)),'K   T(target) = ',num2str(T),' K  I = ',num2str(I),' uA     Helium Level ',HeLVL,' %'])
            drawnow
            dT=0.001;
            Trate=0.1;
            if (k>1)
                if (prod((abs(RR(k,:)-RR(k-1,:))<10)))
                    dT=0.01;
                    Trate=4;
                end
            end
                
            T=T-dT;
            if TT(k)<2
                stop=1;
            end
            TEMP(PPMS,T,Trate,1)
        k=k+1;
        end
	end

    CURRENT(PPMS,[1 2 3],[0 0 0])
        T=7.6;
    TEMP(PPMS,T,1,0)
    save('R(T,diff_I)_Nb_BolaX261','file')
    
    % Low Helium Level, reset field and stop measurement
    if str2double(HeLVL)<52 
  
        break
    end
end

FIELD(PPMS,0,100,2,0); % Field->0 

dlmwrite('R(T,diff_I)_Nb_BolaX261.txt',file)
% fclose(PPMS);
