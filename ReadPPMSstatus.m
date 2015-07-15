function [Status, StatusTXT]=ReadPPMSstatus(PPMSobj)
stop=0;
while stop==0
    [values]=GetValue(query(PPMSobj, 'GETDAT? 1'));
    try
        S=dec2bin(values(3),16);
        stop=1;
    end
end
    
Status=zeros(4,1);
for k=1:4
    indx=(4*(k-1)+1:4*(k-1)+4);
    Status(5-k)=bin2dec(S(indx));
end

k=1;
switch Status(k)
    case 0
        StatusTXT{k}='Status unknown';
    case 1
        StatusTXT{k}='Normal stability at target temperature';
    case 2
        StatusTXT{k}='Stable';
    case 5
        StatusTXT{k}='Within tolerance, waiting for equilibrium';
    case 6
        StatusTXT{k}='Temperaturen ot in tolerance, not valid';
    case 7
        StatusTXT{k}='Filling/Emptying reservoir';
    case 10
        StatusTXT{k}='Standby mode invoked';
    case 13
        StatusTXT{k}='Temperature control disabled';
    case 14
        StatusTXT{k}='Request cannot complete, impedance not functioning';
    case 15
        StatusTXT{k}='General failure in temperatures system, contact Quantume Design';
end

k=2;
switch Status(k)
    case 0
        StatusTXT{k}='Status unknown';
    case 1
        StatusTXT{k}='Persistent mode, stable';
    case 2
        StatusTXT{k}='Persist switch warming';
    case 3
        StatusTXT{k}='Persist switch cooling';
    case 4
        StatusTXT{k}='Driven mode, stable at final field';
    case 5
        StatusTXT{k}='Driven mode, final approach';
    case 6
        StatusTXT{k}='Charging magnet at specified voltage';
    case 7
        StatusTXT{k}='Discharging magnet';
    case 8
        StatusTXT{k}='Current error, incorrect current in magnet';
    case 15
        StatusTXT{k}='General failure in magnet control system';
end

k=3;
switch Status(k)
    case 0
        StatusTXT{k}='Status unknown';
    case 1
        StatusTXT{k}='Purged and sealed';
    case 2
        StatusTXT{k}='Vented and sealed';
    case 3
        StatusTXT{k}='Sealed, condition unknown';
    case 4
        StatusTXT{k}='Perfomring purge/seal routine';
    case 5
        StatusTXT{k}='Perfomring vent/seal sequence';
    case 8
        StatusTXT{k}='Pumping continuously';
    case 9
        StatusTXT{k}='Flooding continuously';
    case 15
        StatusTXT{k}='General failure in gas control system';
end

k=4;
switch Status(k)
    case 0
        StatusTXT{k}='Status unknown';
    case 1
        StatusTXT{k}='Sample stopped at target value';
    case 5
        StatusTXT{k}='Sample moving toward set point';
    case 8
        StatusTXT{k}='Sample hit limit switch';
    case 9
        StatusTXT{k}='Sample hit index switch';
    case 15
        StatusTXT{k}='General failure';
end

StatusTXT=StatusTXT';