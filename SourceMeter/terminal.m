function terminal( sm_obj, term )
%terminal( sm_obj, term ) sets the measurment terminal of the source meter
%   term = 'front' || 'rear'

fprintf(sm_obj, [':route:terminals ',term]);

end

