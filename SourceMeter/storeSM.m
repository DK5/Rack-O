function storeSM( sm_obj )
%store simply commands the source meter to start storing measurements in the
%buffer
%   sm_obj is the source meter object
fprintf(sm_obj, ':trace:clear');            % Clear buffer
fprintf(sm_obj, ':trace:points 2500');
fprintf(sm_obj, ':trace:feed sense');       % Store raw input readings
fprintf(sm_obj, ':trace:tstamp absolute');  % timestamp
fprintf(sm_obj, ':trace:feed:control next');% Start storing readings
end