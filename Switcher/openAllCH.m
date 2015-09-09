function openAllCH (obj)
% openAllCH opens *ALL* channels
%   obj is the function object

% Execution %
try 
    fprintf(obj, 'reset()');
catch
    error('Error opening ALL channels');
end

              
