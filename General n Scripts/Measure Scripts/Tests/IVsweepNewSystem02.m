close all

% GPdis
switch_obj=GPcon(5,0);
nv_obj=GPcon(6,0);
sm_obj=GPcon(23,0);
PPMS=GPcon(15,0);

conf=readtable('D:\Dropbox\Yeshurun\Lior Shani\Test_new_system\conf.csv');
Im=table2array(conf(:,1));
Ip=table2array(conf(:,2));
Vm=table2array(conf(:,3));
Vp=table2array(conf(:,4));


clear data
setupIV(nv_obj,sm_obj);
% ZeroV(nv_obj,switch_obj,5)
IntegrationTime(nv_obj,1/50)
beeper(sm_obj)

Ispan=40e3;
points=51;

% T=3;
% for T=[3:0.2:6,6.1:0.1:6.8,6.9:0.05:7.3,7.32:0.02:7.6]
for T=[3:0.1:7.6,7.31:0.02:7.51]
    T
    if T==7.31
        Ispan=10e3;
    end
TEMP(PPMS,T,3,0)
wait4temp(PPMS)
pause(10)
tic
for k=2:2%length(Im)
    openAllCH (switch_obj)
    switchCurrent (switch_obj, 'ON', Im(k), Ip(k));
    switchVoltage (switch_obj, 'ON', Vm(k), Vp(k));
    pause(0.1)
    wait4OPC(switch_obj)
%     [Idata,Vdata] = executeIV( nv_obj , sm_obj , 'v' ,-50e-6,50e-6,1e-6);
%     [Idata,Vdata] = executeIVspan( nv_obj , sm_obj , 'c' ,0.01754e6,0.0001e6,401,'u');
    [IdataUP,VdataUP] = executeIVspan( nv_obj , sm_obj , 'c' ,0,Ispan,points,'u');
    [IdataDN,VdataDN] = executeIVspan( nv_obj , sm_obj , 'c' ,0,Ispan,points,'d');
    close all
%         data.T{Tindx,k-1}=T;
%         data.I{Tindx,k-1}=Idata;
%         data.V{Tindx,k-1}=Vdata;
    subplot(2,1,1)
%         plot(Idata*1e6,Vdata*1e6,'.')
%         xlabel('I [\muA]')
%         ylabel('V [\muVolt]')
        plot(IdataUP*1e3,VdataUP*1e3,'b*',IdataDN*1e3,VdataDN*1e3,'g.','DisplayName',{'UP','DOWN'})
        xlabel('I [mA]')
        ylabel('V [mV]')
        legend('show','Location','north')
%         hold all
    subplot(2,1,2)
        plot(IdataUP(2:end)*1e3,diff(VdataUP)./diff(IdataUP'),'b*',...
             IdataDN(2:end)*1e3,diff(VdataDN)./diff(IdataDN'),'g.',...
             'DisplayName',{'UP','DOWN'})
        ylabel('dR [ \Omega ]')
%         xlabel('V [Volt]')
        xlabel('I [mA]')
        axis([-inf inf -0.5 5])
        legend('show','Location','north')
%         hold all
    drawnow
    savefig(['40nm_Nb_T=',num2str(T),'K.fig'])
    print(['40nm_Nb_T=',num2str(T),'K.png'],'-dpng')
    save(['40nm_Nb_T=',num2str(T),'K.mat'],'IdataUP','IdataDN','VdataUP','VdataDN')
end
toc
datestr(now)
end
%     save('D:\Dropbox\Yeshurun\Lior Shani\Test_new_system\IVsweepMeasurement_test','data')

% execute(PPMS,{'SHUTDOWN'})
