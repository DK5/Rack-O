function [ field_status ] = FieldQ( PPMSObj )
%FieldQ() - returns current status of set Magnetic Field in the ppMS as
%specified bt last FIELD command.
%   Magnetic Field Query -(Immediate Mode Only) Returns the Field, Rate,
%   ApproachMode, and MagnetMode as specified by the last FIELD command.
%   return value field_status will be a cell array consisting the different
%   parameters by listing:
%   field_status{1} = Set field (as number value)
%   field_status{2} = Set Rate (as number value)
%   field_status{3} = Approach Mode (as string value)
%   field_status{4} = Magnet Mode Mode (as string value)
%   -------------------------------------------------------------------
CMD='FIELD?';
data=str2num(query(PPMSObj, CMD));       %ask ppms for data
field_status{1} = data(1);               %set field
field_status{2} = data(2)                %set rate
switch data(3)                           % approach coding
    case 0
        field_status{3} = 'Linear';
    case 1
        field_status{3} = 'No Overshoot';
    case 2
        field_status{3} = 'Oscillation';
end

switch data(4)                           %magnet mode coding
    case 0
        field_status{4} = 'Persistant';
    case 1
        field_status{4} = 'Driven';
end
end