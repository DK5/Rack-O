function [ temp_status ] = TempQ( PPMSObj )
%TempQ() - returns current status of set Temprature in the ppMS as
%specified bt last TEMP command.
%   Temp Query -(Immediate Mode Only) Returns the temp, Rate and
%   ApproachMode as specified by the last TEMP command.
%   return value temp_status will be a cell array consisting the different
%   parameters by listing:
%   temp_status{1} = Set temp (as number value)
%   temp_status{2} = Set Rate (as number value)
%   temp_status{3} = Approach Mode (as string value)
%   -------------------------------------------------------------------
CMD='TEMP?';
data=str2num(query(PPMSObj, CMD)); %ask ppms for data
temp_status{1} = data(1);    %set temp
temp_status{2} = data(2);    %set rate
switch data(3)                        % approach coding
    case 0
        temp_status{3} = 'Fast Settle';
    case 1
        temp_status{3} = 'No Overshoot';
end
end