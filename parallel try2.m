ind  = [2,15,25];
GPIB = GPcon(ind);
[lockin,PPMS,fung] = GPIB{:};

delete(gcp);
data = zeros(1,50);
ppmsData = zeros(2,50);
        
tic
lab = parpool('local',2);

%PP = composite(2);
%PP{1} = ppmsData;
%PP{2} = data;

spmd
  switch labindex
      case 1
        tic
        for k = 1:50
            ppmsData(:,k) = ReadPPMSdata(PPMS,[1 2]);
        end
        time1 = toc;
      case 2
        tic
        for k = 1:50
            data(k) = askTrace(lockin,1);
        end
        time2 = toc;
  end
end
total = toc;
delete(gcp)
