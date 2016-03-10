clear
t1 = timer;
t1.TimerFcn = @(myTimerObj,~) disp(num2str(myTimerObj.TasksExecuted));
t1.Period = 0.5;
t1.TasksToExecute = 3;
t1.ExecutionMode = 'fixedRate';


b = zeros(1,5);
k = 0;
t2 = timer;
arr = zeros(1,5);
t2.UserData = {0,arr};
t2.TimerFcn = @(myTimerObj,~) randtm(myTimerObj);
t2.TimerFcn = 'k=k+1;b(k)=rand+k;-k';
t2.Period = 0.3;
t2.TasksToExecute = 5;

c = zeros(1,5);
j = 0;
t3 = timer;
arr = zeros(1,5);
t3.UserData = {0,arr};
t3.TimerFcn = @(myTimerObj,~) randtm(myTimerObj);
t3.TimerFcn = 'j=j+1;c(j)=rand+j;-j*100';
t3.Period = 0.4;
t3.TasksToExecute = 5;
t3.ExecutionMode = 'fixedRate';

start(t1);
start(t2);
start(t3);

wait(timerfind);  % wait for all timers
delete(timerfind);

'Timers Stopped'