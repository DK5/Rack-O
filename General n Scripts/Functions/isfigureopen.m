function [output]=isfigureopen()
if isempty(get(0,'CurrentFigure'))
    output=0;
else
    output=1;
end