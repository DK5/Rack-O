function [ ] = storeSM( sm_obj , func)
%store simply commands the source meter to start storing measurements in the
%buffer
%   sm_obj is the source meter object

measureFunc(sm_obj, func);

fprintf(sm_obj, ':trace:clear');            % Clear buffer
fprintf(sm_obj, ':trace:points 2500');
fprintf(sm_obj, ':trace:feed sense');       % Store raw input readings
fprintf(sm_obj, ':trace:tstamp absolute');  % timestamp
fprintf(sm_obj, ':trace:feed:control next');% Start storing readings
end