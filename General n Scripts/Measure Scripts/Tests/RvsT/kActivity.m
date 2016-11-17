%%
function [TimeSig,dV,dI,dR] = kActivity
    nv_obj = getappdata(0,'nv_obj');
    sm_obj = getappdata(0,'sm_obj');
    legs = getappdata(0,'legs');
    
    Ip = legs(:,1);
    Im = legs(:,2);
    Vp = legs(:,3);
    Vm = legs(:,4);
    
    switch_obj = getappdata(0,'switch_obj');
    for CH=1:length(Im)
        openAllCH(switch_obj)
        switchCurrent(switch_obj, 'ON', Im(CH), Ip(CH));
        switchVoltage(switch_obj, 'ON', Vm(CH), Vp(CH));
        pause(0.1)
%         wait4OPC(switch_obj)
        [Idata,Vdata] = deltaExecuteSpan(nv_obj,sm_obj,'c',0,0.1,1);
        dV(CH)=Vdata(:,2);
        dI(CH)=Idata(:,2);
        dR(CH)=-dV(t,CH)./dI(t,CH);
        TimeSig = toc;
    end
end
