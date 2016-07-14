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
setupIV(nv_obj,sm_obj);

for k=1:length(Im)
    openAllCH (switch_obj)
    switchCurrent (switch_obj, 'ON', Im(k), Ip(k));
    switchVoltage (switch_obj, 'ON', Vm(k), Vp(k));
    pause(0.1)
    wait4OPC(sm_obj)
%     [Idata,Vdata] = executeIV( nv_obj , sm_obj , 'v' ,-10,10,0.1);
    [Idata,Vdata] = executeIVspan( nv_obj , sm_obj , 'v' ,3,5,101);
%         data.T{Tindx,k-1}=T;
%         data.I{Tindx,k-1}=Idata;
%         data.V{Tindx,k-1}=Vdata;
    plot(Vdata,Idata/1e-6,'.')
    hold all
    ylabel('I [\muA]')
    xlabel('V [Volt]')
end
    save('D:\Dropbox\Yeshurun\Lior Shani\Test_new_system\IVsweepMeasurement_test','data')

execute(PPMS,{'SHUTDOWN'})
