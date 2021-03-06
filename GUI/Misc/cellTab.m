function [CommandsTab] = cellTab(CommandsCell)
%Tab identation

CommandsTab = strtrim(CommandsCell); % remove all tabs
TABS = zeros(length(CommandsTab),1);
counter = 0;
errorind = 0;
eeind = 1;

% counts TAB
for i = 1:length(CommandsTab)
    if iscell(CommandsTab{i,1})
        % it is cell
        CommandsTabCell = CommandsTab{i,1};
        for j = 1:length(CommandsTabCell)
            if length(CommandsTabCell{j,1}) < 3
                continue;
            elseif strcmp(CommandsTab{i,1},'End sequence')
                continue;
            end
            str = CommandsTabCell{j,1}(1:3);
            switch lower(str)
                case {'for','sca','whi'}
                    TABS(i) = counter;
                    counter = counter + 1;
                case 'end'
                    counter = counter - 1;
                    TABS(i) = counter;
                otherwise
                    TABS(i) = counter;
            end
            tab = repmat('    ',1,TABS(i));
            CommandsTabCell{j,1} = [tab, CommandsTabCell{j,1}];
        end
        CommandsTab{i,1} = CommandsTabCell;
    else
        % write TAB
        if length(CommandsTab{i,1}) < 3
            continue;
        elseif strcmp(CommandsTab{i,1},'End sequence')
            continue;
        end
        str = CommandsTab{i,1}(1:3);
        switch lower(str)
            case {'for','sca','whi'}
                TABS(i) = counter;
                counter = counter + 1;
            case 'end'
                counter = counter - 1;
                if counter < 0
                    errorind(eeind) = i;
                    eeind = eeind + 1;
%                     error('End statement cannot be above loop');
                end
                TABS(i)=counter;
            otherwise
                TABS(i)=counter;
        end
        % applies TAB to cells
        tab = repmat('    ',1,TABS(i));
        CommandsTab{i,1} = [tab, CommandsTab{i,1}];
    end
end

if errorind     % there is error
    if ~counter  % equal number of scan & end
        error('End statement cannot be above loop');
    else
        CommandsTab(errorind) = [];
    end
end

end