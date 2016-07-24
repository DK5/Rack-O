close all

GPdis
switch_obj=GPcon(5,0);
nv_obj=GPcon(6,0);
sm_obj=GPcon(23,0);
PPMS=GPcon(15,0);

conf=readtable('D:\Dropbox\Yeshurun\Lior Shani\Test_new_system\conf.csv');
Im=table2array(conf(:,1));
Ip=table2array(conf(:,2));
Vm=table2array(conf(:,3));
Vp=table2array(conf(:,4));


deltaSetup( nv_obj , sm_obj )
relative(nv_obj,'OFF')
IntegrationTime(nv_obj,1/50)
beeper(sm_obj)

close all
dR=[];
dV=[];
dI=[];
T=0;
t=1;
TEMP(PPMS,7.3,1,1)
wait4temp(PPMS)
TEMP(PPMS,7.6,0.02,0)
while T(end)<7.58
    T(t)=ReadPPMSdata(PPMS,1); % Meausres temperature
    for CH=2:2%1:length(Ip)
    %     openAllCH (switch_obj);switchCurrent (switch_obj, 'ON', Im(CH), Ip(CH));switchVoltage (switch_obj, 'ON', Vm(CH), Vp(CH));    wait4OPC(switch_obj);
%         [Idata,Vdata] = deltaExecuteSpan(nv_obj,sm_obj,'c',0,1,10);
%         dV(end+1:end+length(Vdata))=-Vdata(:,2);
%         dI(end+1:end+length(Vdata))=Idata(:,2);
        [Idata,Vdata] = deltaExecuteSpan(nv_obj,sm_obj,'c',0,1e3,1);
        dV(t)=-Vdata(:,2);
        dI(t)=Idata(:,2);
        dR(t)=dV(t)./dI(t);
        plot(T,dR,'o')
        drawnow
    end
    t=t+1;
end

