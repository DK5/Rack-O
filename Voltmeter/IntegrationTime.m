% Determine the measurement Integration Time of the nanovoltmeter in [sec]
function IntegrationTime( nV_Obj , t )
if t>=200e-6 && t<=1
    fprintf( nV_Obj, [':SENSe:VOLTage:APERture ',num2str(t)]);
else
    disp('Error: 200 usec < Integration Time < 1 sec')
end
