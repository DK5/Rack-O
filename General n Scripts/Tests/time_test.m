load time_test.mat

Time = linspace(0,10,5);
tic
for t = 1:length(Time)
    
    %
    timesig (k)= toc
    pause(2.5-timesig(k));
end

