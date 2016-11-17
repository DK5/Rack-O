% GPdis()
%disconnect all GPIB instruments
instruments = instrfind;
for in=1:length(instruments)
    fclose(instruments(in));
end

