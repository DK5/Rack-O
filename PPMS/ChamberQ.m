function [ chamber_status ] = ChamberQ( PPMSObj )
%CHAMBERQ() - returns current status of set CHAMBERrature in the ppMS as
%   specified bt last CHAMBER command.
%   CHAMBER Query -(Immediate Mode Only) Returns the chamber, as specified by the last chamber command.
%   return value chamber_status will be a string specifying the mode.
%   -------------------------------------------------------------------
CMD='CHAMBER?';
data=GetValue(query(PPMSObj, CMD)); %ask ppms for data
switch data                      % approach coding
    case 0
        chamber_status = 'Seal Immediately';
    case 1
        chamber_status = 'Purge and Seal';
    case 2
        chamber_status = 'Vent and Seal';
    case 3
        chamber_status = 'Pump Continuously';
    case 4
        chamber_status = 'Vent Continuously';
end
end