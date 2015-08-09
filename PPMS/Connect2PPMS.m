function [PPMS]=Connect2PPMS()
PPMS = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 15, 'Tag', '');
if isempty(PPMS)
    PPMS = gpib('NI', 0, 15);
else
    fclose(PPMS);
    PPMS = PPMS(1);
end
fopen(PPMS);

