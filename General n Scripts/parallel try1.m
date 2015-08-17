ind  = [2,15,25];
GPIB = GPcon(ind);
[lockin,PPMS,fung] = GPIB{:};

delete(gcp);



data = zeros(1,50);
ppmsData = zeros(2,50);
        
tic
lab = parpool('local',2);

%PP = Composite(2);
PP{1} = ppmsData;
PP{2} = data;

spmd
  switch labindex
      case 1
        tic
        for k = 1:50
            % PP{1}(k,:) = ReadPPMSdata(PPMS,[1 2]);
            ppmsData(k,1)=2*k-1;
        end
        time1 = toc;
      case 2
        tic
        for k = 1:50
           % PP{2}(k) = askTrace(lockin,1);
           data(k)=2*k;
        end
        time2 = toc;
  end
end
total = toc;
%ppmsData = PP{1};
%data = PP{2};

save('parVar','data' , 'ppmsData' , 'time1','time2','total');

delete(gcp)