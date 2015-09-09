function openAllCH (obj)
% openAllCH opens *ALL* channels
%   obj is the function object

% Loops generating string of ALL channels %
str = '';

for i = 1:6
    for j = 1:16
        str = [str,'1',num2str(i),num2str(j,'%02d'),','];          
    end
end

str = str(1:end-1);

% Execution %
try 
    fprintf(obj, ['channel.open("',str,'")']);
catch
    error('Error opening ALL channels');
end

              
