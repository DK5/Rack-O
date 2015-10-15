function xPointM(cs_obj,points)
% xPointM(cs_obj,points) sets the source meter to 4 point measurement or 2 point measurement
%   cs_obj = source meter object
%   points = 2 or 4

switch points
    case 2
        state = 'OFF';
    case 4
        state = 'ON';
end
fprintf(cs_obj,[':SYSTem:RSENse ',state]);
end