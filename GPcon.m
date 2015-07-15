function [ obj1 ] = GPcon( ind )
%Connect GPIB device
%   Connect via GPIB a device with index ind

len = length(ind);  % get the length of the array
obj1 = cell(len,1); % generate cell array of size len

% connect all GPIB
for ii = 1:len
obj1{ii} = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', ind(ii), 'Tag', '');    % Find a GPIB object.
% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1{ii})
    obj1{ii} = gpib('NI', 0, ind(ii));
else
    fclose(obj1{ii});
    obj1{ii} = obj1{ii}(1);
end

% Connect to instrument object, obj{ii}.
fopen(obj1{ii});
end
end

