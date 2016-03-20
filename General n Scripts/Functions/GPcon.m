function [ obj1 ] = GPcon( address , NI_ind )
%Connect GPIB device
%   Connect via GPIB a device with address

% Find address a GPIB object.
obj1 = instrfind('Type', 'gpib', 'Boardaddressex', NI_ind, 'PrimaryAddress', address, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', NI_ind, address);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);