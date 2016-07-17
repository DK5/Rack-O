close all

GPdis
switch_obj=GPcon(5,0);
nv_obj=GPcon(6,0);
sm_obj=GPcon(23,0);
PPMS=GPcon(15,0);

conf=readtable('conf.csv');
Im=table2array(conf(:,1));
Ip=table2array(conf(:,2));
Vm=table2array(conf(:,3));
Vp=table2array(conf(:,4));


clear data
ZeroV(nv_obj,switch_obj,5)
setupIV(nv_obj,sm_obj);
IntegrationTime(nv_obj,0.02)
for k=1:length(Im)
    openAllCH (switch_obj)
    switchCurrent (switch_obj, 'ON', Im(k), Ip(k));
    switchVoltage (switch_obj, 'ON', Vm(k), Vp(k));
    pause(0.1)
    wait4OPC(sm_obj)
%     [Idata,Vdata] = executeIV( nv_obj , sm_obj , 'v' ,-10,10,0.1);
    [Idata,Vdata] = executeIVspan( nv_obj , sm_obj , 'v' ,-5,2,101);
%         data.T{Tindx,k-1}=T;
%         data.I{Tindx,k-1}=Idata;
%         data.V{Tindx,k-1}=Vdata;
    subplot(2,1,1)
        plot(Vdata,Idata/1e-6,'.')
        ylabel('I [\muA]')
        xlabel('V [Volt]')
        hold all
    subplot(2,1,2)
        plot(Vdata(2:end),diff(Vdata)./diff(Idata')*1e-6,'.')
        ylabel('diff R [ M \Omega ]')
        xlabel('V [Volt]')
        hold all
    drawnow
end
    save('D:\Dropbox\Yeshurun\Lior Shani\Test_new_system\IVsweepMeasurement_test','data')

execute(PPMS,{'SHUTDOWN'})
