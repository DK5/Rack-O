clear
t = timer; 
t.TimerFcn = @(myTimerObj,~) disp(num2str(myTimerObj.TasksExecuted));
t.Period = 0.5;
t.TasksToExecute = 3;
t.ExecutionMode = 'fixedRate';
start(t)


clear
b = zeros(1,4);
k = 0;
t = timer;
t.UserData = zeros(1,4);
t.TimerFcn = @(myTimerObj,~) randtm(myTimerObj);

t.TimerFcn = 'k=k+1;b(k)=rand;k';


t.Period = 0.5;
t.TasksToExecute = 100;
t.ExecutionMode = 'fixedRate';
start(t)

k=k+1;