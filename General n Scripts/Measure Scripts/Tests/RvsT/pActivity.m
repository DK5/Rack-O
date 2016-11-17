function [TimeSig , data] = pActivity
    PPMS = getappdata(0,'PPMS');
    data = ReadPPMSdata(PPMS,[1,2])'; % Meausres temperature
    disp(['T = ',num2str(data(1)),' K'])
    TimeSig = toc;
end