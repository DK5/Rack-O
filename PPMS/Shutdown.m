function Shutdown(PPMSobj)
try
    fprintf(PPMSobj, 'SHUTDOWN');
catch
    disp('Error')
end
