IntegrationTime( nV_obj , 0.1 )
switchVoltage2(switch_obj,'ON', 5, 5);   %set legs for nanoVoltmeter
clear data
t=1;
figure
while isfigureopen()
    data(t)=mean(read( nV_obj ));
    plot(data)
    drawnow
    pause(1)
    t=t+1;
end