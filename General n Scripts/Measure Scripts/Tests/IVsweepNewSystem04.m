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

Ispan=130e3;
points=401;
T=2.5;
TEMP(PPMS,T,0.5,0)
wait4temp(PPMS)

% T=3;
% for T=[3:0.2:6,6.1:0.1:6.8,6.9:0.05:7.3,7.32:0.02:7.6]
for T=[2.5:0.05:7.6]
    T
%     if T==7.31
%         Ispan=10e3;
%     end
TEMP(PPMS,T,0.1,0)
wait4temp(PPMS)
pause(10)
wait4temp(PPMS)
tic
% figure
for CH=1:length(Im)
    openAllCH (switch_obj)
    switchCurrent (switch_obj, 'ON', Im(CH), Ip(CH));
    switchVoltage (switch_obj, 'ON', Vm(CH), Vp(CH));
    pause(0.1)
    wait4OPC(switch_obj)

    [IdataUP,VdataUP] = executeIVspan( nv_obj , sm_obj , 'c' ,0,Ispan,points,'u');
    [IdataDN,VdataDN] = executeIVspan( nv_obj , sm_obj , 'c' ,0,Ispan,points,'d');

    subplot(2,3,CH)
        plot(IdataUP*1e3,VdataUP*1e3,'b*',IdataDN*1e3,VdataDN*1e3,'g.','DisplayName',{'UP','DOWN'})
        xlabel('I [mA]')
        ylabel('V [mV]')
        legend('show','Location','north')
    subplot(2,3,CH+3)
        plot(IdataUP(2:end)*1e3,diff(VdataUP)./diff(IdataUP'),'b*',...
             IdataDN(2:end)*1e3,diff(VdataDN)./diff(IdataDN'),'g.',...
             'DisplayName',{'UP','DOWN'})
        ylabel('dR [ \Omega ]')
        xlabel('I [mA]')
        axis([-inf inf -0.5 7])
        legend('show','Location','north')
%         hold all
    drawnow
    save(['40nm_Nb_CH',num2str(CH),'_T=',num2str(T),'K.mat'],'IdataUP','IdataDN','VdataUP','VdataDN')
end
    savefig(['40nm_Nb_T=',num2str(T),'K.fig'])
    print(['40nm_Nb_T=',num2str(T),'K.png'],'-dpng')
toc
datestr(now)
end
%     save('D:\Dropbox\Yeshurun\Lior Shani\Test_new_system\IVsweepMeasurement_test','data')

execute(PPMS,{'SHUTDOWN'})
