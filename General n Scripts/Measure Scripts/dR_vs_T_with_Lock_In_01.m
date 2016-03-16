close all
clear all

lk=GPcon(2);             %connect to lock-in
ppms=GPcon(15);          %connect to ppms
fg=GPcon(25);            %connect to function generator

% TEMP(ppms,12,4,1)   
% wait4temp(ppms)
% pause(3*60)

setTrace(lk,1,1,0,0,0); % set trace 1 as Rn = magnitude noise

freq(fg,213)            % set frequency
ampl(fg,10);             % set amplitude to 1V
output(fg,'on50');      % set output to 50 ohm
execute(fg);

Bits=[23];              % MAP23
TEMP(ppms,2,0.2,1)       % send to temperature
file(30000,5)=0;        
a=find(file(:,1)==0);
    k=min(a)

T=ReadPPMSdata(ppms,Bits); %Temperature from MAP23
TT=T;
RR=0;
figure;
    h=plot(TT,RR,'.','XDataSource','TT','YDataSource','RR');
tic
while T>2.1
    Time=toc; %time
    T=ReadPPMSdata(ppms,Bits); %Temperature from MAP23
    dI=askampl(fg)/1e5*1e6; % dI = Current in uA
    dV=askTrace(lk,1)*1e6; % dV = Voltage in uV
    dR=dV/dI; % dR = dV/dI (ohm)
    file(k,:)=[Time T dI dV dR];
    TT=file(1:k,2);
    RR=file(1:k,5);
    refreshdata(h,'caller')
    drawnow
    if mod(k,100)==1
        autoGain(lk);
    end
    k=k+1;
    if k>length(file)-2
        file(length(file)+1e4,5)=0;
    end
end

output(fg,0)
execute(fg)

TEMP(ppms,100,4,1) 