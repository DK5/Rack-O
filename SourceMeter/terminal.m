function terminal( sm_obj, term )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch lower(term)
    case 'rear'
        str = 'rear';
    case 'front'
        str = 'front';
end

fprintf(sm_obj, [':route:terminals ',str]);

end

