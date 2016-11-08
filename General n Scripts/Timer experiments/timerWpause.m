ct = {1}; k=0;
t1 = timer;
t1.TimerFcn = 'k=k+1;ct{k} = datestr(now)';
t1.Period = 0.5;
t1.ExecutionMode = 'fixedRate';

start(t1);
disp('pause started');
pause(5);
disp('pause ended');
datestr(now)
stop(t1);