clear data
ZeroV(nv_obj,switch_obj,5)
deltaSetup( nv_obj , sm_obj ,21,0)
IntegrationTime(nv_obj,0.02)
for k=1:length(Im)
    openAllCH (switch_obj)
    switchCurrent (switch_obj, 'ON', Im(k), Ip(k));
    switchVoltage (switch_obj, 'ON', Vm(k), Vp(k));
    pause(0.1)
    wait4OPC(sm_obj)
%     [Idata,Vdata] = executeIV( nv_obj , sm_obj , 'v' ,-10,10,0.1);
%     [Idata,Vdata] = executeIVspan( nv_obj , sm_obj , 'v' ,-5,2,101);
    [Idata,Vdata] = deltaExecuteSpan(nv_obj,sm_obj,'c',-5,2,2)
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